{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.ContaCorrente where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postContaCorrenteInsereR :: Handler Value
postContaCorrenteInsereR = do
    contacorrente <- requireJsonBody :: Handler ContaCorrente
    cid <- runDB $ insert contacorrente
    sendStatusJSON created201 (object ["data" .= (fromSqlKey cid)]) 

-- select * from ContaCorrente where id = cid
getContaCorrenteBuscarR :: ContaCorrenteId -> Handler Value
getContaCorrenteBuscarR cid = do 
    contacorrente <- runDB $ get404 cid
    sendStatusJSON ok200 (object ["data" .= (toJSON contacorrente)])
    
deleteContaCorrenteApagarR :: ContaCorrenteId -> Handler Value
deleteContaCorrenteApagarR cid = do 
    _ <- runDB $ get404 cid
    runDB $ delete cid
    sendStatusJSON noContent204 (object ["data" .= (fromSqlKey cid)])
    
--get saldo usando um map pra somar o valor de todas as operações