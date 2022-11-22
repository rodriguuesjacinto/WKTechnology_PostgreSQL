object daoDataModule: TdaoDataModule
  Height = 480
  Width = 640
  object RESTClient: TRESTClient
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWSPessoas/Pessoa'
    Params = <>
    SynchronizedEvents = False
    Left = 64
    Top = 72
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 112
    Top = 144
  end
  object RESTResponse: TRESTResponse
    Left = 176
    Top = 72
  end
  object FDStanStorageBinLink: TFDStanStorageBinLink
    Left = 448
    Top = 184
  end
  object FDStanStorageJSONLink: TFDStanStorageJSONLink
    Left = 272
    Top = 184
  end
end
