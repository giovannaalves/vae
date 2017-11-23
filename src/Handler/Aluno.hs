{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Aluno where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- $ curl -v -X POST https://haskdelta-romefeller.caluno -d '{"nome":"Giovanna","limite":22.5,"cpf":"488258966333", "respid":1}'
-- insert into Aluno values ('Giovanna',22.5,'488258966333',1)
postAlunoInsereR :: Handler Value
postAlunoInsereR = do
    aluno <- requireJsonBody :: Handler Aluno
    aid <- runDB $ insert aluno
    sendStatusJSON created201 (object ["data" .= (fromSqlKey aid)])

-- select * from Aluno where id = aid
getAlunoBuscarR :: AlunoId -> Handler Value
getAlunoBuscarR aid = do 
    aluno <- runDB $ get404 aid
    sendStatusJSON ok200 (object ["data" .= (toJSON aluno)])

-- delete * from Aluno where id = aid    
deleteAlunoApagarR :: AlunoId -> Handler Value
deleteAlunoApagarR aid = do 
    _ <- runDB $ get404 aid
    runDB $ delete aid
    sendStatusJSON noContent204 (object ["data" .= (fromSqlKey aid)])

-- update Aluno set nome= '' where id = aid
putAlunoAlterarR :: AlunoId -> Handler Value
putAlunoAlterarR aid = do
    _ <- runDB $ get404 aid
    novoAluno <- requireJsonBody :: Handler Aluno
    runDB $ replace aid novoAluno
    sendStatusJSON noContent204 (object ["data" .= (fromSqlKey aid)])

getSaldoR:: AlunoId -> Handler Value
getSaldoR aid = do
    _ <- runDB $ get404 aid
    saldo <- runDB $ 
    