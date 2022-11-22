--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 13.6

-- Started on 2022-11-21 22:18:04

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

--
-- TOC entry 205 (class 1255 OID 16439)
-- Name: InsertPessoaEndereco(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."InsertPessoaEndereco"(_idpessoa integer, _dscep character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
   if not exists (select e.idpessoa, e.dscep from endereco e where e.idpessoa = _idpessoa and e.dscep = _dscep ) then
      insert into endereco (idpessoa,dscep) values (_idpessoa,_dscep) ;
   end if ;   
END
$$;


ALTER PROCEDURE public."InsertPessoaEndereco"(_idpessoa integer, _dscep character varying) OWNER TO postgres;

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
-- TOC entry 3872 (class 0 OID 0)
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
-- TOC entry 201 (class 1259 OID 16406)
-- Name: pessoa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa (
    idpessoa bigint NOT NULL,
    f1natureza integer[] NOT NULL,
    dsdocumento character varying(20) NOT NULL,
    nmprimeiro character varying(100) NOT NULL,
    nmsegundo character varying(100) NOT NULL,
    dtregistro date
);
ALTER TABLE ONLY public.pessoa ALTER COLUMN f1natureza SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN dsdocumento SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN nmprimeiro SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN nmsegundo SET STATISTICS 0;
ALTER TABLE ONLY public.pessoa ALTER COLUMN dtregistro SET STATISTICS 0;


ALTER TABLE public.pessoa OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16404)
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
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 200
-- Name: pessoa_idpessoa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pessoa_idpessoa_seq OWNED BY public.pessoa.idpessoa;


--
-- TOC entry 3722 (class 2604 OID 16420)
-- Name: endereco idendereco; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN idendereco SET DEFAULT nextval('public.endereco_idendereco_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16409)
-- Name: pessoa idpessoa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa ALTER COLUMN idpessoa SET DEFAULT nextval('public.pessoa_idpessoa_seq'::regclass);


--
-- TOC entry 3864 (class 0 OID 16417)
-- Dependencies: 203
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco (idendereco, idpessoa, dscep) FROM stdin;
\.


--
-- TOC entry 3865 (class 0 OID 16423)
-- Dependencies: 204
-- Data for Name: endereco_integracao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) FROM stdin;
\.


--
-- TOC entry 3862 (class 0 OID 16406)
-- Dependencies: 201
-- Data for Name: pessoa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa (idpessoa, f1natureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) FROM stdin;
\.


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 202
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_idendereco_seq', 1, false);


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 200
-- Name: pessoa_idpessoa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pessoa_idpessoa_seq', 1, false);


--
-- TOC entry 3728 (class 2606 OID 16427)
-- Name: endereco_integracao endereco_integracao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_integracao
    ADD CONSTRAINT endereco_integracao_pkey PRIMARY KEY (idendereco);


--
-- TOC entry 3726 (class 2606 OID 16422)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- TOC entry 3724 (class 2606 OID 16414)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (idpessoa);


--
-- TOC entry 3729 (class 2606 OID 16428)
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
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2022-11-21 22:18:18

--
-- PostgreSQL database dump complete
--

