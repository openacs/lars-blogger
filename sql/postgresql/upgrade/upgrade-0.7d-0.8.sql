--
-- upgrade-0.7d-0.8.sql
-- 
-- @author Lars Pind
-- @author Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
-- 
-- @cvs-id $Id$
--

-- added notifications

\i ../notifications-init.sql

-- Index the existing published blog entries

\i lars-blogger-sc-index.sql
