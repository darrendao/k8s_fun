venv: venv/bin/activate

venv/bin/activate: requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; pip install -r requirements.txt > /dev/null
	touch venv/bin/activate

synth: venv
	. venv/bin/activate; cdk synth > ../template.yaml

.PHONY: synth
