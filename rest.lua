

MODEL                   = {}
MODEL.__index           = MODEL
MODEL.Storage           = {}

MODEL.FromResource      = function(self, source, name)
                            MODEL.Storage[source] = {}
                            MODEL.Storage[source][name] = {
                              queryString = self.queryString,
                              path = self.path,
                              data = {},
                              vars = {},
                              isSaved = false
                            }
                            self.source = source
                            self.name = name
                            self.model = MODEL.Storage[source][name]
                            self.props = {}
                            REST.DirectGet(self.path, self.queryString, function(data)
                              MODEL.UpdateData(source, name, data)
                            end)
                            print(' :: FXRest -> Action: From Resource -> Model: ' .. name .. ' | Source: #' .. source .. ' | Status: Successful - 200')
                            return self
                          end

MODEL.CreateFromResource = function(self, source, name, data, method)
                            if method == nil then
                              method = RESTConfig.DefCreateMethod
                            end
                            MODEL.Storage[source] = {}
                            MODEL.Storage[source][name] = {
                              queryString = self.queryString,
                              path = self.path,
                              data = {},
                              vars = {},
                              isSaved = false
                            }
                            self.source = source
                            self.name = name
                            self.model = MODEL.Storage[source][name]
                            self.props =
                            MODEL.Create(self, data, method)
                            print(' :: FXRest -> Action: New Resource -> Model: ' .. name .. ' | Source: #' .. source .. ' | Status: Successful - 200')
                            return self
                          end

MODEL.UpdateData        = function(source, name, data)
                            MODEL.Storage[source][name].data = data
                            MODEL.Storage[source][name].isSaved = true
                          end

MODEL.Get               = function(source, name)
                            local self = setmetatable({}, MODEL)
                            self.source = source
                            self.name = name
                            self.model = MODEL.Storage[source][name]
                            self.props = {}
                            return self
                          end

MODEL.Prop              = function(self, prop, value)
                            self.props[prop] = value
                            return self
                          end

MODEL.Var               = function(self, var, value)
                            MODEL.Storage[self.source][self.name].vars[var] = value
                            return self
                          end

MODEL.Vars              = function(self, vars)
                            for var,value in pairs(vars) do
                              MODEL.Storage[self.source][self.name].vars[var] = value
                            end
                            return self
                          end

MODEL.GetVar            = function(self, var)
                            return MODEL.Storage[self.source][self.name].vars[var]
                          end

MODEL.GetVars           = function(self, var)
                            return MODEL.Storage[self.source][self.name].vars
                          end

MODEL.Props             = function(self, props)
                            for prop,value in pairs(props) do
                              self.props[prop] = value
                            end
                            return self
                          end

MODEL.Save              = function(self, method)
                            MODEL.Storage[self.source][self.name].isSaved = false
                            if method == nil then
                              method = RESTConfig.DefSaveMethod
                            end
                            PerformHttpRequest(
                              self.model.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  REST.DirectGet(self.model.path, self.model.queryString, function(data)
                                    MODEL.UpdateData(self.source, self.name, data)
                                  end)
                                  print(' :: FXRest -> Action: Update -> Model: ' .. self.name .. ' | Source: #' .. self.source .. ' | Status: Successful - ' .. code)
                                else
                                  print(' :: FXRest -> Action: Update -> Model: ' .. self.name .. ' | Source: #' .. self.source .. ' | Status: Failure - ' .. code)
                                end
                              end,
                              method,
                              json.encode(self.props),
                              RESTConfig.Headers
                            )
                            self.props = {}
                            return self
                          end

MODEL.Create            = function(self, data, method)
                            MODEL.Storage[self.source][self.name].isSaved = false
                            if method == nil then
                              method = RESTConfig.DefCreateMethod
                            end
                            PerformHttpRequest(
                              self.model.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  REST.DirectGet(self.model.path, self.model.queryString, function(data)
                                    MODEL.UpdateData(self.source, self.name, data)
                                  end)
                                  print(' :: FXRest -> Action: Create -> Model: ' .. self.name .. ' | Source: #' .. self.source .. ' | Status: Successful - ' .. code)
                                else
                                  print(' :: FXRest -> Action: Create -> Model: ' .. self.name .. ' | Source: #' .. self.source .. ' | Status: Failure - ' .. code)
                                end
                              end,
                              method,
                              json.encode(data),
                              RESTConfig.Headers
                            )
                            self.props = {}
                            return self
                          end

MODEL.Refresh           = function(self)
                            MODEL.Storage[self.source][self.name].isSaved = false
                            REST.DirectGet(self.model.path, self.model.queryString, function(data)
                              MODEL.UpdateData(self.source, self.name, data)
                            end)
                            return self
                          end

MODEL.HasSaved          = function(self)
                            return MODEL.Storage[self.source][self.name].isSaved
                          end

MODEL.WhenSaved         = function(self)
                            while not MODEL.HasSaved(self) do
                              Citizen.Wait(100)
                            end
                            return self
                          end

MODEL.Data              = function(self)
                            return MODEL.Storage[self.source][self.name].data
                          end

------------------------------------------------------------------------------------------------------------

REST                    = {}
REST.__index            = REST


-- REST Class Functions
-- REST API Resource (Acts as Constructor for REST Calls)
REST.Resource           = function(endpoint, key)
                            local self = setmetatable({}, REST)
                            if key ~= nil then
                              self.path = RESTConfig.Host .. RESTConfig.APIPath .. endpoint .. '/' .. key
                            else
                              self.path = RESTConfig.Host .. RESTConfig.APIPath .. endpoint
                            end
                            self.props = {}
                            return self
                          end

REST.All                = function(self, endpoint)
                            self.path = self.path .. '/' .. endpoint
                            return self
                          end

REST.One                = function(self, key)
                            self.path = self.path .. '/' .. key
                            return self
                          end

REST.Prop              = function(self, key, value)
                            self.props[key] = value
                            return self
                          end

REST.Props             = function(self, params)
                            for key,value in pairs(params) do
                              self.props[key] = value
                            end
                            return self
                          end

REST.Get                = function(self, callback, query)
                            if query == nil then
                              query = '?'
                            end
                            PerformHttpRequest(
                              self.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  print(' :: FXRest -> Action: GET | Path: ' .. self.path .. ' | Status: Successful - ' .. code)
                                  callback(true, json.decode(text), headers)
                                else
                                  print(' :: FXRest -> Action: GET | Path: ' .. self.path .. ' | Status: Failure - ' .. code)
                                  callback(false, code, headers)
                                end
                              end,
                              'GET',
                              "",
                              RESTConfig.Headers
                            )
                          end

REST.Update             = function(self, callback, data, method)
                            if data == nil then
                              data = self.props
                            else
                              for k,v in pairs(data) do
                                self.props[k] = v
                              end
                              data = self.props
                            end
                            if method == nil then
                              method = RESTConfig.DefUpdateMethod
                            end
                            PerformHttpRequest(
                              self.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  print(' :: FXRest -> Action: Update | Path: ' .. self.path .. ' | Status: Successful - ' .. code)
                                  callback(true, json.decode(text), headers)
                                else
                                  print(' :: FXRest -> Action: Update | Path: ' .. self.path .. ' | Status: Failure - ' .. code)
                                  callback(false, code, headers)
                                end
                              end,
                              method,
                              json.encode(data),
                              RESTConfig.Headers
                            )
                            self.props = {}
                            return self
                          end

REST.Delete             = function(self, callback, data, method)
                            if data == nil then
                              data = self.props
                            else
                              for k,v in pairs(data) do
                                self.props[k] = v
                              end
                              data = self.props
                            end
                            if method == nil then
                              method = RESTConfig.DefDeleteMethod
                            end
                            PerformHttpRequest(
                              self.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  print(' :: FXRest -> Action: Delete | Path: ' .. self.path .. ' | Status: Successful - ' .. code)
                                  callback(true, json.decode(text), headers)
                                else
                                  print(' :: FXRest -> Action: Delete | Path: ' .. self.path .. ' | Status: Failure - ' .. code)
                                  callback(false, code, headers)
                                end
                              end,
                              method,
                              json.encode(data),
                              RESTConfig.Headers
                            )
                            self.props = {}
                            return self
                          end

REST.Create             = function(self, callback, data, method)
                            if data == nil then
                              data = self.props
                            else
                              for k,v in pairs(data) do
                                self.props[k] = v
                              end
                              data = self.props
                            end
                            if method == nil then
                              method = RESTConfig.DefCreateMethod
                            end
                            PerformHttpRequest(
                              self.path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  print(' :: FXRest -> Action: Create | Path: ' .. self.path .. ' | Status: Successful - ' .. code)
                                  callback(true, json.decode(text), headers)
                                else
                                  print(' :: FXRest -> Action: Create | Path: ' .. self.path .. ' | Status: Failure - ' .. code)
                                  callback(false, code, headers)
                                end
                              end,
                              method,
                              json.encode(data),
                              RESTConfig.Headers
                            )
                            self.props = {}
                            return self
                          end

REST.DirectGet          = function(path, query, callback)
                            if query == nil then
                              query = '?'
                            end
                            PerformHttpRequest(
                              path,
                              function(code, text, headers)
                                if RESTHelper.IsSuccess(code) then
                                  callback(json.decode(text))
                                else
                                  callback({})
                                end
                              end,
                              'GET',
                              "",
                              RESTConfig.Headers
                            )
                          end
