Feature: Listar Enquetes
Como um cliente
Quero poder ver todas as Enquetes
Para poder saber o resultado e poder dar minha opnião

Scenario: Com internet
Dado que o cliente tem conexão com a internet
Quando solicitar para ver as enquetes 
então o sistema deve exibir as enquetes 
e armazenar os dados atualizados no cache

Scenario: Sem internet 
Dado que o cliente não têm conexão com a internet 
Quando solicitar para ver as enquetes 
Então o sistema deve exibir as enquetes que foram gravadas no cache no último acesso