
RESTHelper                    = {}
RESTHelper.DebugTable         = function(tbl, indent)
                                  if not indent then indent = 0 end
                                  for k, v in pairs(tbl) do
                                    formatting = string.rep("  ", indent) .. k .. " -> "
                                    if type(v) == "table" then
                                      print(formatting)
                                      RESTHelper.DebugTable(v, indent+1)
                                    else
                                      print(formatting .. tostring(v))
                                    end
                                  end
                                end

RESTHelper.IsSuccess          = function(code)
                                  if RESTConfig.SuccessCodes[tostring(code)] ~= nil then
                                    return true, RESTConfig.SuccessCodes[code]
                                  else
                                    return false, code
                                  end
                                end
