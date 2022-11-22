--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 13.6

-- Started on 2022-11-22 04:38:48

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16417)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    idendereco bigint NOT NULL,
    idpessoa integer NOT NULL,
    dscep character varying(15)
);
ALTER TABLE ONLY public.endereco ALTER COLUMN idendereco SET STATISTICS 0;
ALTER TABLE ONLY public.endereco ALTER COLUMN idpessoa SET STATISTICS 0;
ALTER TABLE ONLY public.endereco ALTER COLUMN dscep SET STATISTICS 0;


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16415)
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO postgres;

--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 202
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_idendereco_seq OWNED BY public.endereco.idendereco;


--
-- TOC entry 204 (class 1259 OID 16423)
-- Name: endereco_integracao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco_integracao (
    idendereco bigint NOT NULL,
    dsuf character varying(50),
    nmcidade character varying(100),
    nmbairro character varying(50),
    nmlogradouro character varying(100),
    dscomplemento character varying(100)
);
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN idendereco SET STATISTICS 0;
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN dsuf SET STATISTICS 0;
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN nmcidade SET STATISTICS 0;
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN nmbairro SET STATISTICS 0;
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN nmlogradouro SET STATISTICS 0;
ALTER TABLE ONLY public.endereco_integracao ALTER COLUMN dscomplemento SET STATISTICS 0;


ALTER TABLE public.endereco_integracao OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16447)
-- Name: pessoa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa (
    idpessoa bigint NOT NULL,
    f1natureza integer NOT NULL,
    dsdocumento character varying(20) NOT NULL,
    nmprimeiro character varying(100) NOT NULL,
    nmsegundo character varying(100) NOT NULL,
    dtregistro date
);
ALTER TABLE ONLY public.pessoa ALTER COLUMN dsdocumento SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN nmprimeiro SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN nmsegundo SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN dtregistro SET STATISTICS 0;


ALTER TABLE public.pessoa OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16445)
-- Name: pessoa_idpessoa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pessoa_idpessoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pessoa_idpessoa_seq OWNER TO postgres;

--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 205
-- Name: pessoa_idpessoa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pessoa_idpessoa_seq OWNED BY public.pessoa.idpessoa;


--
-- TOC entry 3721 (class 2604 OID 16420)
-- Name: endereco idendereco; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN idendereco SET DEFAULT nextval('public.endereco_idendereco_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 16450)
-- Name: pessoa idpessoa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa ALTER COLUMN idpessoa SET DEFAULT nextval('public.pessoa_idpessoa_seq'::regclass);


--
-- TOC entry 3726 (class 2606 OID 16427)
-- Name: endereco_integracao endereco_integracao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_integracao
    ADD CONSTRAINT endereco_integracao_pkey PRIMARY KEY (idendereco);


--
-- TOC entry 3724 (class 2606 OID 16422)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- TOC entry 3728 (class 2606 OID 16452)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (idpessoa);


--
-- TOC entry 3729 (class 2606 OID 16453)
-- Name: endereco endereco_fk_pessoa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_fk_pessoa FOREIGN KEY (idpessoa) REFERENCES public.pessoa(idpessoa) ON DELETE CASCADE;


--
-- TOC entry 3730 (class 2606 OID 16433)
-- Name: endereco_integracao endereco_integracao_fk_endereco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_integracao
    ADD CONSTRAINT endereco_integracao_fk_endereco FOREIGN KEY (idendereco) REFERENCES public.endereco(idendereco) ON DELETE CASCADE;


--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2022-11-22 04:39:10

--
-- PostgreSQL database dump complete
--

