SERVICE_NAME=hello-world-printer
MY_DOCKER_NAME=$(SERVICE_NAME)

.PHONY: test

deps:
		pip install -r requirements.txt; \
		pip install -r test_requirements.txt

test:
	PYTHONPATH=. py.test --verbose -s
lint:
	flake8 hello_world test
run:
	PYTHONPATH=. FLASK_APP=hello_world flask run
test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=.
	PYTHONPATH=. py.test --verbose -s --cov=. --cov-report xml

test_xunit:
	PYTHONPATH=. py.test -s --cov=. --cov-report xml --junit-xml=test_results.xml

docker_build:
				docker build  -t $(SERVICE_NAME) .

docker_run: docker_build
								docker run \
												--name $(SERVICE_NAME)-dev \
												-p 5000:5000 \
												-d $(SERVICE_NAME)


docker_stop:
				docker stop $(SERVICE_NAME)-dev

beataclayton = $(USERNAME)


docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag $(SERVICE_NAME) $(USERNAME)/$(SREVICE_NAME); \
  docker push $(USERNAME)/$(SERVICE_NAME); \
  docker logout;
