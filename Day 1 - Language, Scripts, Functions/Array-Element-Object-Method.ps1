$services = get-service

($services[54].DisplayName)

"The name of the service is $($services[54].DisplayName.ToUpper())."