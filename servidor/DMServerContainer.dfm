object ServerContainer: TServerContainer
  Height = 271
  Width = 415
  object DSServer: TDSServer
    Left = 64
    Top = 19
  end
  object DSHTTPService: TDSHTTPService
    HttpPort = 8080
    Server = DSServer
    Filters = <>
    Left = 176
    Top = 23
  end
  object DSPessoa: TDSServerClass
    OnGetClass = DSPessoaGetClass
    Server = DSServer
    Left = 128
    Top = 152
  end
end
