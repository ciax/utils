SSL system consists of 
 1. root CA Certificate/Key
 2. server Certificate/Key
 3. client Certificate/Key (optional)

These scripts are configured by looking up the database associated with the site name.

Basic manipulation scripts
 a. ssl-newkey (makes private key which is universal for any certificates)
 b. ssl-request (makes certificate request file)
 c. ssl-sign (sign with CA key upon the request to the certificate file)

Basic information scripts
 a. ssl-check (check consistency among key,csr,crt files) 
 b. ssl-verify (check the relationship between crt files)
 c. ssl-show (show the crt file information)

Procedure for generating files ( All files are stored in ~/.var/ssl )
 1.Make root CA certificate (Just one time)
  ssl-rootca.sh [root site] -> rootca files (.key,.crt) (.csr isn't needed any more)
 2.Make server private key and request (make it at each server)
  ssl-request [server site]  -> csr file (.csr)
 3.Make server certificate
  ssl-sign [rootca] [server site] -> server crt file (.crt)

Procedure for installation
 - For client
   Install rootca.crt to each browser/system
 - For server
   Install site_prv.key site.crt to apropriate location
