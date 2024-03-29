{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postUsuarioInsereR :: Handler Value
postUsuarioInsereR = do
    usuario <- requireJsonBody :: Handler Usuario
    uid <- runDB $ insert usuario
    sendStatusJSON created201 (object ["data" .= (fromSqlKey uid)])

-- select * from Usuario where id = uid
getUsuarioBuscarR :: UsuarioId -> Handler Value
getUsuarioBuscarR uid = do 
    usuario <- runDB $ get404 uid
    sendStatusJSON ok200 (object ["data" .= (toJSON usuario)])
    
deleteUsuarioApagarR :: UsuarioId -> Handler Value
deleteUsuarioApagarR uid = do 
    _ <- runDB $ get404 uid
    runDB $ delete uid
    sendStatusJSON noContent204 (object ["data" .= (fromSqlKey uid)])

-- UPDATE Usuario SET usuario.nome = nome WHERE usuario.id == uid
patchAlteraNomeR :: UsuarioId -> Text -> Handler Value
patchAlteraNomeR uid nome = do 
    _ <- runDB $ get404 uid
    runDB $ update uid [UsuarioNome =. nome]
    sendStatusJSON noContent204 (object ["data" .= (fromSqlKey uid)])
    