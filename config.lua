
RESTConfig                  = {}
RESTConfig.Host             = "http://localhost"
RESTConfig.APIPath          = "/api/v1/" -- Ensure you have your trailing slash. It is not checked for.

RESTConfig.Headers          = {
                                ['Content-Type'] = 'application/json',
                                ['Accept'] = 'application/json'
                              }

RESTConfig.SuccessCodes     = {
                                ['200'] = "OK",
                                ['201'] = "Created",
                                ['202'] = "Accepted",
                                ['203'] = "Non-Authoritive Information",
                                ['204'] = "No Content"
                              }


RESTConfig.DefSaveMethod    = 'POST'
RESTConfig.DefCreateMethod  = 'POST'
RESTConfig.DefDeleteMethod  = 'POST'
RESTConfig.DefUpdateMethod  = 'POST'
