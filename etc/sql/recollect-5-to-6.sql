BEGIN;

-- Automatically delete reminders when the subscription is deleted.
ALTER TABLE reminders DROP CONSTRAINT reminders_subscription_id_fkey;
ALTER TABLE reminders ADD CONSTRAINT reminders_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (6);

COMMIT;
