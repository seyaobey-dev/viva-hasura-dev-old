SET check_function_bodies = false;
CREATE TABLE public.groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    creator_id uuid NOT NULL,
    group_name text NOT NULL,
    contribution_amount numeric,
    recurrency text,
    recurrency_day integer,
    ratings numeric DEFAULT '0'::numeric NOT NULL
);
CREATE TABLE public.invitation_statuses (
    value text NOT NULL,
    description text NOT NULL
);
CREATE TABLE public.invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    group_id uuid NOT NULL,
    sender_user_id uuid NOT NULL,
    receiver_user_id uuid,
    receiver_phone_number text,
    status text NOT NULL
);
CREATE TABLE public.members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    group_id uuid NOT NULL,
    user_id uuid NOT NULL,
    contribution_amount numeric NOT NULL,
    recurrency text NOT NULL,
    recurrency_day integer NOT NULL,
    ratings numeric DEFAULT '0'::numeric NOT NULL
);
CREATE TABLE public.payment_statuses (
    value text NOT NULL,
    description text NOT NULL
);
CREATE TABLE public.payment_types (
    value text NOT NULL,
    description text NOT NULL
);
CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    group_id uuid NOT NULL,
    member_id uuid NOT NULL,
    period_id uuid NOT NULL,
    payment_amount numeric NOT NULL,
    payment_type text NOT NULL,
    payment_status text NOT NULL,
    recipient_name text,
    recipient_phone text
);
CREATE TABLE public.periods (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    group_id uuid NOT NULL,
    period_index integer NOT NULL,
    member_id uuid,
    completed_at timestamp with time zone NOT NULL,
    period_active boolean NOT NULL
);
CREATE TABLE public.recurrencies (
    value text NOT NULL,
    description text NOT NULL
);
ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_creator_id_group_name_key UNIQUE (creator_id, group_name);
ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.invitation_statuses
    ADD CONSTRAINT invitation_statuses_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_group_id_user_id_key UNIQUE (group_id, user_id);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.payment_statuses
    ADD CONSTRAINT payment_statuses_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.payment_types
    ADD CONSTRAINT payment_types_description_key UNIQUE (description);
ALTER TABLE ONLY public.payment_types
    ADD CONSTRAINT payment_types_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_group_id_period_index_member_id_key UNIQUE (group_id, period_index, member_id);
ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.recurrencies
    ADD CONSTRAINT recurrencies_description_key UNIQUE (description);
ALTER TABLE ONLY public.recurrencies
    ADD CONSTRAINT recurrencies_pkey PRIMARY KEY (value);
CREATE TRIGGER set_public_groups_updated_at BEFORE UPDATE ON public.groups FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_groups_updated_at ON public.groups IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_invitations_updated_at BEFORE UPDATE ON public.invitations FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_invitations_updated_at ON public.invitations IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_members_updated_at BEFORE UPDATE ON public.members FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_members_updated_at ON public.members IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_payments_updated_at BEFORE UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_payments_updated_at ON public.payments IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_periods_updated_at BEFORE UPDATE ON public.periods FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_periods_updated_at ON public.periods IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_recurrency_fkey FOREIGN KEY (recurrency) REFERENCES public.recurrencies(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_receiver_user_id_fkey FOREIGN KEY (receiver_user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_status_fkey FOREIGN KEY (status) REFERENCES public.invitation_statuses(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_recurrency_fkey FOREIGN KEY (recurrency) REFERENCES public.recurrencies(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_status_fkey FOREIGN KEY (payment_status) REFERENCES public.payment_statuses(value) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_type_fkey FOREIGN KEY (payment_type) REFERENCES public.payment_types(value) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_period_id_fkey FOREIGN KEY (period_id) REFERENCES public.periods(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON UPDATE CASCADE ON DELETE CASCADE;
SET check_function_bodies = false;
INSERT INTO public.invitation_statuses (value, description) VALUES ('PENDING', 'Pending');
INSERT INTO public.invitation_statuses (value, description) VALUES ('COMPLETED', 'Completed');
INSERT INTO public.invitation_statuses (value, description) VALUES ('REJECTED', 'Rejected');
INSERT INTO public.payment_statuses (value, description) VALUES ('PENDING', 'Pending');
INSERT INTO public.payment_statuses (value, description) VALUES ('COMPLETED', 'Completed');
INSERT INTO public.payment_statuses (value, description) VALUES ('FAILED', 'Failed');
INSERT INTO public.payment_statuses (value, description) VALUES ('CANCELLED', 'Cancelled');
INSERT INTO public.payment_types (value, description) VALUES ('MONEY_IN', 'Money In');
INSERT INTO public.payment_types (value, description) VALUES ('MONEY_OUT', 'Money Out');
INSERT INTO public.recurrencies (value, description) VALUES ('DAILY', 'Daily');
INSERT INTO public.recurrencies (value, description) VALUES ('WEEKLY', 'Weekly');
INSERT INTO public.recurrencies (value, description) VALUES ('MONTHLY', 'Monthly');
