PGDMP     "                
    z            postgres    12.4    12.4                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    13318    postgres    DATABASE     ?   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    2844                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    4            ?            1259    33135    endereco_idendereco_seq    SEQUENCE     ?   CREATE SEQUENCE public.endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.endereco_idendereco_seq;
       public          postgres    false    4            ?            1259    33137    endereco    TABLE     ?   CREATE TABLE public.endereco (
    idendereco bigint DEFAULT nextval('public.endereco_idendereco_seq'::regclass) NOT NULL,
    idpessoa integer NOT NULL,
    dscep character varying(15)
);
    DROP TABLE public.endereco;
       public         heap    postgres    false    205    4            ?            1259    33148    endereco_integracao    TABLE       CREATE TABLE public.endereco_integracao (
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
 '   DROP TABLE public.endereco_integracao;
       public         heap    postgres    false    4            ?            1259    33127    pessoa_idpessoa_seq    SEQUENCE     |   CREATE SEQUENCE public.pessoa_idpessoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.pessoa_idpessoa_seq;
       public          postgres    false    4            ?            1259    33129    pessoa    TABLE     ^  CREATE TABLE public.pessoa (
    idpessoa bigint DEFAULT nextval('public.pessoa_idpessoa_seq'::regclass) NOT NULL,
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
    DROP TABLE public.pessoa;
       public         heap    postgres    false    203    4                      0    33137    endereco 
   TABLE DATA           ?   COPY public.endereco (idendereco, idpessoa, dscep) FROM stdin;
    public          postgres    false    206   
                 0    33148    endereco_integracao 
   TABLE DATA           p   COPY public.endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) FROM stdin;
    public          postgres    false    207   '                 0    33129    pessoa 
   TABLE DATA           f   COPY public.pessoa (idpessoa, f1natureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) FROM stdin;
    public          postgres    false    204   D                  0    0    endereco_idendereco_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.endereco_idendereco_seq', 1, false);
          public          postgres    false    205                        0    0    pessoa_idpessoa_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.pessoa_idpessoa_seq', 1, false);
          public          postgres    false    203            ?
           2606    33152 ,   endereco_integracao endereco_integracao_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.endereco_integracao
    ADD CONSTRAINT endereco_integracao_pkey PRIMARY KEY (idendereco);
 V   ALTER TABLE ONLY public.endereco_integracao DROP CONSTRAINT endereco_integracao_pkey;
       public            postgres    false    207            ?
           2606    33142    endereco endereco_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);
 @   ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
       public            postgres    false    206            ?
           2606    33134    pessoa pessoa_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (idpessoa);
 <   ALTER TABLE ONLY public.pessoa DROP CONSTRAINT pessoa_pkey;
       public            postgres    false    204            ?
           2606    33143    endereco endereco_fk_pessoa    FK CONSTRAINT     ?   ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_fk_pessoa FOREIGN KEY (idpessoa) REFERENCES public.pessoa(idpessoa) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_fk_pessoa;
       public          postgres    false    2701    204    206            ?
           2606    33153 3   endereco_integracao endereco_integracao_fk_endereco    FK CONSTRAINT     ?   ALTER TABLE ONLY public.endereco_integracao
    ADD CONSTRAINT endereco_integracao_fk_endereco FOREIGN KEY (idendereco) REFERENCES public.endereco(idendereco) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.endereco_integracao DROP CONSTRAINT endereco_integracao_fk_endereco;
       public          postgres    false    207    206    2703                  x?????? ? ?            x?????? ? ?            x?????? ? ?     