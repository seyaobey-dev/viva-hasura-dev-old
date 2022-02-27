alter table "public"."members"
  add constraint "members_notification_frequency_fkey"
  foreign key ("notification_frequency")
  references "public"."notification_frequencies"
  ("value") on update restrict on delete restrict;
