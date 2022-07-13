# aws-test-task

Appache server is installed on Webserver instance and can be checked in browser by address http://3.123.24.247/

MySQL sever is installed and configured on MySQL instance and running on the port 3110

To access MySQL from Webserver host on MySQL host you should connect to Webserver host by SSH and provided .pem file and run the command:
### sudo mysql -u root -h ip-172-16-2-31.eu-central-1.compute.internal --port=3110
