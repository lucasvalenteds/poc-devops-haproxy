SERVICE = server
PROXY_URL = http://localhost:4000
SCALE ?= 5

up:
	@npm --prefix ./server install
	@npm --prefix ./server run build
	@docker-compose up --build --detach --scale $(SERVICE)=$(SCALE) --force-recreate

down:
	@docker-compose down --remove-orphans --volumes

logs:
	@docker-compose logs --follow $(SERVICE)

test:
	@npx autocannon --connections 30 --method GET --duration 30 $(PROXY_URL)
