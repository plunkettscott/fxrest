
MODEL                   = {}
MODEL.__index           = MODEL
MODEL.Storage           = {}

MODEL.FromResource      = function(self, source, name)
                            MODEL.Storage[source] = {}
                            MODEL.Storage[source][name] = {
                              queryString = self.queryString,
                              path = self.path,
                              props = {},
                              data = {},
                              vars = {},
                              isSaved = false
                            }
                            REST.DirectGet(self.path, self.queryString, function(data)
                              MODEL.UpdateData(source, name, data)
                            end)
                            print(' :: FXRest -> Action: Store -> Model: ' .. name .. ' | Source: #' .. source .. ' | Status: Successful - OK')
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

MODEL.HasSaved          = function(self)
                            return MODEL.Storage[self.source][self.name].isSaved
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

REST.Get                = function(self)
                            print(self.path)
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
