--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.run DROP CONSTRAINT run_build_id;
ALTER TABLE ONLY public.build_suppress DROP CONSTRAINT build_suppress_id;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_distribution;
ALTER TABLE ONLY public.run DROP CONSTRAINT "$1";
ALTER TABLE ONLY public.build DROP CONSTRAINT "$1";
DROP INDEX public.run_run_id_build_id;
DROP INDEX public.run_exit_signal;
DROP INDEX public.run_build_id;
ALTER TABLE ONLY public.server DROP CONSTRAINT server_pkey;
ALTER TABLE ONLY public.run_suppress DROP CONSTRAINT run_suppress_pkey;
ALTER TABLE ONLY public.run DROP CONSTRAINT run_pkey;
ALTER TABLE ONLY public.distribution DROP CONSTRAINT distribution_pkey;
ALTER TABLE ONLY public.deployment DROP CONSTRAINT deployment_pkey;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_pkey;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_application_name_key;
DROP SEQUENCE public.build_build_id_seq;
DROP FUNCTION public.plpgsql_call_handler();
DROP TABLE public.server;
DROP TABLE public.run_suppress;
DROP TABLE public.run;
DROP TABLE public.distribution;
DROP TABLE public.deployment;
DROP TABLE public.build_suppress;
DROP TABLE public.build;
DROP PROCEDURAL LANGUAGE plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

-- COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: build; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE build (
    build_id integer DEFAULT nextval(('public.build_build_id_seq'::text)::regclass) NOT NULL,
    application_name character varying(50) NOT NULL,
    application_version character varying(50) NOT NULL,
    application_release character varying(50) NOT NULL,
    build_distribution character varying(50) NOT NULL,
    build_date timestamp without time zone NOT NULL,
    deployment_name character varying(50) NOT NULL
);


--
-- Name: build_suppress; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE build_suppress (
    build_id integer NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- Name: deployment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deployment (
    deployment_name character varying(50) NOT NULL
);


--
-- Name: distribution; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE distribution (
    distribution_name character varying(50) NOT NULL
);


--
-- Name: run; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE run (
    run_id character varying(24) NOT NULL,
    build_id integer NOT NULL,
    version character varying(255),
    sparsity integer NOT NULL,
    exit_signal smallint NOT NULL,
    exit_status smallint NOT NULL,
    date timestamp without time zone NOT NULL,
    server_name character varying(50) NOT NULL,
    CONSTRAINT run_exit_choice CHECK (((exit_status = 0) OR (exit_signal = 0))),
    CONSTRAINT run_exit_signal CHECK ((exit_signal >= 0)),
    CONSTRAINT run_exit_status CHECK ((exit_status >= 0)),
    CONSTRAINT run_sparsity CHECK ((sparsity > 0))
);


--
-- Name: run_suppress; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE run_suppress (
    run_id character varying(24) NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- Name: server; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE server (
    server_name character varying(50) NOT NULL
);


--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- Name: build_build_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE build_build_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: build_build_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE build_build_id_seq OWNED BY build.build_id;


--
-- Name: build_application_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_application_name_key UNIQUE (application_name, application_version, application_release, build_distribution);


--
-- Name: build_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_pkey PRIMARY KEY (build_id);


--
-- Name: deployment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deployment
    ADD CONSTRAINT deployment_pkey PRIMARY KEY (deployment_name);


--
-- Name: distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY distribution
    ADD CONSTRAINT distribution_pkey PRIMARY KEY (distribution_name);


--
-- Name: run_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_pkey PRIMARY KEY (run_id);


--
-- Name: run_suppress_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY run_suppress
    ADD CONSTRAINT run_suppress_pkey PRIMARY KEY (run_id);


--
-- Name: server_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY server
    ADD CONSTRAINT server_pkey PRIMARY KEY (server_name);


--
-- Name: run_build_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX run_build_id ON run USING btree (build_id);


--
-- Name: run_exit_signal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX run_exit_signal ON run USING btree (exit_signal);


--
-- Name: run_run_id_build_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX run_run_id_build_id ON run USING btree (run_id, build_id);


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY build
    ADD CONSTRAINT "$1" FOREIGN KEY (deployment_name) REFERENCES deployment(deployment_name);


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY run
    ADD CONSTRAINT "$1" FOREIGN KEY (server_name) REFERENCES server(server_name);


--
-- Name: build_distribution; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_distribution FOREIGN KEY (build_distribution) REFERENCES distribution(distribution_name);


--
-- Name: build_suppress_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY build_suppress
    ADD CONSTRAINT build_suppress_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- Name: run_build_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_build_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- PostgreSQL database dump complete
--

