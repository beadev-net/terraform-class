ACR_NAME=az1acrsappz

build-consumer:
	@echo "Building consumer..."
	@az acr build -t consumer:0.0.1 --build-arg=APP_MODE=consumer --registry ${ACR_NAME} -f Dockerfile .
	@echo "Consumer built successfully."

build-producer:
	@echo "Building producer..."
	@az acr build -t producer:0.0.1 --build-arg=APP_MODE=producer --registry ${ACR_NAME} -f Dockerfile .
	@echo "Producer built successfully."