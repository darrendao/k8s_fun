# Override these by exporting them as environment variables.
ACCOUNT_ID       ?= $(shell aws sts get-caller-identity --output text --query 'Account')
AWS_REGION       ?= us-west-2
STACK_NAME       ?= chp-test-ddao
ARTIFACTS_BUCKET ?= artifacts-$(ACCOUNT_ID)-$(AWS_REGION)
ENVIRONMENT_NAME ?= dev

TIMESTAMP := $(shell date +%s )

all: package

clean:
	/bin/rm -rf src/__pycache__/
	/bin/rm -rf src/htmlcov/
	/bin/rm -rf src/integration_test/__pycache__/
	/bin/rm -rf src/test/__pycache__/
	/bin/rm -f src/.coverage
	/bin/rm -f src/.*test.log
	/bin/rm -f build/*

venv: venv/bin/activate

venv/bin/activate: src/requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; pip install -r src/requirements.txt > /dev/null
	touch venv/bin/activate

lint: venv
	venv/bin/python -m pylint src

test: clean venv
	. venv/bin/activate; bash scripts/test.sh

# Package but don't publish to S3.
package: test lint cdk-ts
	bash scripts/package.sh

# Package and publish to S3.
package-s3: all
	aws s3 cp build/main.zip s3://$(ARTIFACTS_BUCKET)/$(STACK_NAME)-$(ENVIRONMENT_NAME)/$(TIMESTAMP)/

cdk-py:
	cd cdk-py; make synth; cd ..

cdk-ts:
	cd cdk-ts; npm install; cdk synth > ../template.yaml

# Package, publish to S3, and deploy.
deploy: package-s3
	sam deploy \
	  --stack-name $(STACK_NAME)-$(ENVIRONMENT_NAME) \
	  --template-file template.yaml \
	  --capabilities CAPABILITY_IAM \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --parameter-overrides \
	    EnvironmentName=$(ENVIRONMENT_NAME) \
	    ArtifactBucket=$(ARTIFACTS_BUCKET) \
	    ArtifactFolder=$(STACK_NAME)-$(ENVIRONMENT_NAME)/$(TIMESTAMP)

.PHONY: all clean package test package-s3 deploy lint venv venv/bin/activate cdk-ts cdk-py
