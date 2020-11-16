Dieses Projekt beinhaltet den Versuch, einen Nginx Webserver mit dem Inhalt "Hello World!" auf unterschiedliche Weise via Infrastructure as Code über einer Jenkins Pipeline zu deployen. 

Die Bedingungen:

- Die Initialsierung zur Erstellung des Webservers wird durch ein "git push" ausgelöst.

- Der Webserver ist über Port 80 (entweder local oder über einer Public Cloud) mit dem Inhalt "Hello World!" aufrufbar.

- Im zweiten Schritt muss der Webserver ausschließlich über TLS/SSL erreichbar und das SSL Zertifikat gültig sein.

- Als drittes ist der Webserver als Docker Container zu deployen.

- Optional: Die Bereitstellung des Webservers über einer Pipeline.