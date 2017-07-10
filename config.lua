
RESTConfig                  = {}
RESTConfig.Host             = "http://lesa5.dev"
RESTConfig.APIPath          = "/api/v1/" -- Ensure you have your trailing slash. It is not checked for.

RESTConfig.Headers          = {
                                ['Content-Type'] = 'application/json',
                                ['Accept'] = 'application/json',
                                ['Authorization'] = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImUwZTRkM2FmN2U4ZDk0Y2UwNTc1MWE5ZWZmYTM4YmViYWEwM2I1N2U0NjM2OGM2NzIwN2FkOWNkZGEyNGYxYmE3ZmYyYWE2OGI4YmY1ZTNmIn0.eyJhdWQiOiIxIiwianRpIjoiZTBlNGQzYWY3ZThkOTRjZTA1NzUxYTllZmZhMzhiZWJhYTAzYjU3ZTQ2MzY4YzY3MjA3YWQ5Y2RkYTI0ZjFiYTdmZjJhYTY4YjhiZjVlM2YiLCJpYXQiOjE0OTk3MDU5NjYsIm5iZiI6MTQ5OTcwNTk2NiwiZXhwIjoxNTMxMjQxOTY1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.EWIfCZ9yTrHYa2mJWU5jVknCY2K7ZVI6Md0nFtaYGRT9vujOXdSyf4dQzegWK6Lx1_UDJPAY4UKQrQl88r6n4p1QojqzYQoPo6KLd7W75e4biWxyCqZXbz2tCES95ahWJsx4kh4YOLFE_1cyddC18sO99AdtQmSTDVzU72YFmrWIdYLxHrssqY5b2Fnr0mU0fnG8X-AWZGcYcnrn2j5kdHYDPw-rqXdvPrf789Xro_D0wPVsZKxEMU2K30WToyXz4qbX7EPA387BO8SkFyRqbeHfjj51VCtMrIjt_1_jyftVvVoLklzJFLVXM3nEjQvpafE220OBtC8i917qJ7xi0-VmXBYN6Bo8jpZfdjdlWIP0g46LZAYFxzbSqpv8b51jHvQ9gp64BixrG2e50h-vPXpXE86AHxTsshXRPHgAS9GFx8dNhcl3jzj0woTd1cX7px1Z4bV_QZP-hPsKjP_gnebTesfE2IzNqoH1AaXTScoHto_Z3ckBNeIUd658pXuzDlfDW6YBCrqTT4IryS0vmjoLl3amnRkWQmMLKRfs0TGeFJFbCQMUyEVSRGMf5_UaJD3by__onpg7Su7E30V0-sW-2Y3VjDzgzk2e5YyS9_x9p9_L4HhRoJAKV5IvV1LVnTJ47IiPK-TyxlZiqVaHelt5hhRXH6erQ9nigdxEzfk'
                              }

RESTConfig.SuccessCodes     = {
                                ['200'] = "OK",
                                ['201'] = "Created",
                                ['202'] = "Accepted",
                                ['203'] = "Non-Authoritive Information",
                                ['204'] = "No Content"
                              }


RESTConfig.DefSaveMethod    = 'POST'                            
