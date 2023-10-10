 -- add table
CREATE TABLE
  IF NOT EXISTS prompts (
    id uuid DEFAULT gen_random_uuid () NOT NULL,
    prompt text NOT NULL,
    model text DEFAULT 'dreamfusion_stable-diffusion' NOT NULL,
    -- guidance_scale DEFAULT 100 NOT NULL,
    -- steps integer DEFAULT 5000 NOT NULL,
    created_at timestamp
    with
      time zone DEFAULT now () NOT NULL,
      updated_at timestamp
    with
      time zone DEFAULT now () NOT NULL,
      expires_at timestamp
    with
      time zone,
      CONSTRAINT check_prompt_nonempty CHECK ((prompt OPERATOR (<>) '')),
  );

COMMENT ON TABLE prompts IS 'Prompts given by the user for content creation';

COMMENT ON COLUMN prompts.model IS 'The model used to generate the content';

-- COMMENT ON COLUMN guidance_scale IS 'How much the generation follows the text prompt';
-- COMMENT ON COLUMN steps IS '';
CREATE TABLE
  explicit_permissions_bitbucket_projects_jobs (
    id integer NOT NULL,
    state text DEFAULT 'queued',
    failure_message text,
    queued_at timestamp
    with
      time zone DEFAULT now (),
      started_at timestamp
    with
      time zone,
      finished_at timestamp
    with
      time zone,
      process_after timestamp
    with
      time zone,
      num_resets integer DEFAULT 0 NOT NULL,
      num_failures integer DEFAULT 0 NOT NULL,
      last_heartbeat_at timestamp
    with
      time zone,
      worker_hostname text DEFAULT '' NOT NULL,
      project_key text NOT NULL,
      external_service_id integer NOT NULL,
      unrestricted boolean DEFAULT false NOT NULL,
      cancel boolean DEFAULT false NOT NULL,
      CONSTRAINT explicit_permissions_bitbucket_projects_jobs_check CHECK (
        (
          (
            (permissions IS NOT NULL)
            AND (unrestricted IS FALSE)
          )
          OR (
            (permissions IS NULL)
            AND (unrestricted IS TRUE)
          )
        )
      )
  );

CREATE SEQUENCE explicit_permissions_bitbucket_projects_jobs_id_seq AS integer START
WITH
  1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER
  SEQUENCE explicit_permissions_bitbucket_projects_jobs_id_seq OWNED BY explicit_permissions_bitbucket_projects_jobs.id;

-- look at: 
-- code_monitor_trigger_jobs
--
-- run postgres locally
-- create the tables all at once (up.sql and down.sql)
--    no need to think about migrations... no time for that
-- so rename the migrations folder to db
-- set up basestore in internal/database and lib package
--
-- update trigger_job with a file id 
-- 
-- when job finishes, sql trigger insert to prompts
--
-- also make new endpoints in openapi 3 yaml for creating jobs
-- look at createDBWorkerStoreForActionJobs
--
-- ask partner if we can split our teams into a front end team and backend team
-- because of reasons
-- 
-- ************screenshot as approval*************
