--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: feeds; Type: TABLE; Schema: public; Owner: postea
--

CREATE TABLE public.feeds (
    id integer NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.feeds OWNER TO postea;

--
-- Name: feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: postea
--

CREATE SEQUENCE public.feeds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feeds_id_seq OWNER TO postea;

--
-- Name: feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postea
--

ALTER SEQUENCE public.feeds_id_seq OWNED BY public.feeds.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postea
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    feed_id integer NOT NULL,
    body text NOT NULL,
    date timestamp with time zone
);


ALTER TABLE public.posts OWNER TO postea;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postea
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postea;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postea
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: feeds id; Type: DEFAULT; Schema: public; Owner: postea
--

ALTER TABLE ONLY public.feeds ALTER COLUMN id SET DEFAULT nextval('public.feeds_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postea
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: feeds feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: postea
--

ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postea
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: posts posts_feed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postea
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_feed_id_fkey FOREIGN KEY (feed_id) REFERENCES public.feeds(id);


--
-- PostgreSQL database dump complete
--

