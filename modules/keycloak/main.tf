
#TODO
resource "keycloak_realm" "realm" {

  #General
  realm   = var.keycloak_realm
  enabled = true
  display_name = "realm - cloud public"
  user_managed_access = false

  #Login Settings
  registration_allowed     = false
  registration_email_as_username = false
  edit_username_allowed    = false
  reset_password_allowed   = false
  remember_me              = false
  verify_email             = false
  login_with_email_allowed = true
  duplicate_emails_allowed = false
  ssl_required             = "external"

  #Themes
  login_theme   = "keycloak"
  email_theme   = "keycloak"
  account_theme = "keycloak.v2"
  admin_theme   = "keycloak"
  docker_authentication_flow = "docker auth"

  # Auth Settings
  browser_flow = "X509Browser"
  client_authentication_flow = "clients"
  direct_grant_flow = "direct grant"
  reset_credentials_flow = "reset credentials"
  password_policy = "upperCase(1) and length(12) and forceExpiredPasswordChange(365) and notUsername"

  default_default_client_scopes  = []
  default_optional_client_scopes = []

  #Tokens
  default_signature_algorithm = ""
  revoke_refresh_token = false

    #Login timeout
  access_code_lifespan = "1m0s"
  access_code_lifespan_login = "30m0s"
  access_code_lifespan_user_action = "5m0s"

  access_token_lifespan = "5m0s"
  access_token_lifespan_for_implicit_flow  = "15m0s"
  
  action_token_generated_by_admin_lifespan = "12h0m0s"
  action_token_generated_by_user_lifespan  = "5m0s"

  sso_session_idle_timeout = "30m0s"
  sso_session_idle_timeout_remember_me = "0s"
  sso_session_max_lifespan = "10h0m0s"
  sso_session_max_lifespan_remember_me = "0s"

  offline_session_idle_timeout = "720h0m0s"
  offline_session_max_lifespan = "1440h0m0s"
  offline_session_max_lifespan_enabled = false

  internationalization {
    supported_locales = [
      "en",
      "de",
      "es",
      "fr",
      "it"
    ]
    default_locale    = "fr"
  }

  otp_policy {
    algorithm = "HmacSHA512"
    digits = 6
    initial_counter = 0
    look_ahead_window = 1
    period = 30
    type   = "totp"
  }

  security_defenses {
    headers {
      x_frame_options                     = "DENY"
      content_security_policy             = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      content_security_policy_report_only = ""
      x_content_type_options              = "nosniff"
      x_robots_tag                        = "none"
      x_xss_protection                    = "1; mode=block"
      strict_transport_security           = "max-age=31536000; includeSubDomains"
    }
    brute_force_detection {
      permanent_lockout                 = false
      max_login_failures                = 30
      wait_increment_seconds            = 60
      quick_login_check_milli_seconds   = 1000
      minimum_quick_login_wait_seconds  = 60
      max_failure_wait_seconds          = 900
      failure_reset_time_seconds        = 43200
    }
  }
  web_authn_policy {
    acceptable_aaguids = []
    attestation_conveyance_preference = "not specified"
    authenticator_attachment = "not specified"
    avoid_same_authenticator_register = false
    create_timeout = 0
    relying_party_entity_name = "keycloak"
    relying_party_id = "keycloak.example.com"
    require_resident_key = "not specified"
    signature_algorithms =  ["ES256", "ES512", "RS256", "RS512"]
    user_verification_requirement = "not specified"
  }

}

###########################
##  Authentication Flow  ##
###########################

#keycloak_authentication_flow.browser-copy-flow.id
resource "keycloak_authentication_flow" "browser-x509-flow" {
  alias       = "X509Browser"
  realm_id    = var.keycloak_realm
  description = "browser based authentication, With IGCv3 X.509"
  provider_id = "basic-flow"
}

resource "keycloak_authentication_execution" "browser-copy-cookie" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_flow.browser-x509-flow.alias
  authenticator     = "auth-cookie"
  requirement       = "ALTERNATIVE"
}

resource "keycloak_authentication_execution" "browser-copy-kerberos" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_flow.browser-x509-flow.alias
  authenticator     = "auth-spnego"
  requirement       = "DISABLED"
  depends_on        = [ keycloak_authentication_execution.browser-copy-cookie ]
}

resource "keycloak_authentication_execution" "browser-copy-default-idp" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_flow.browser-x509-flow.alias
  authenticator     = "identity-provider-redirector"
  requirement       = "DISABLED"
  depends_on        = [ keycloak_authentication_execution.browser-copy-kerberos ]
}

#resource "keycloak_authentication_execution_config" "config" {
#  realm_id     = var.keycloak_realm
#  execution_id = keycloak_authentication_execution.browser-copy-default-idp.id
#  alias        = "idp-FBI-config"
#  config       = {
#    defaultProvider = "idp-FBI"
#  }
#}

resource "keycloak_authentication_execution" "browser-x509" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_flow.browser-x509-flow.alias
  authenticator     = "auth-x509-client-username-form"
  requirement       = "REQUIRED"
  depends_on        = [ keycloak_authentication_execution.browser-copy-default-idp ]
}

resource "keycloak_authentication_execution_config" "mfa_config" {
  realm_id     = var.keycloak_realm
  execution_id = keycloak_authentication_execution.browser-x509.id
  alias        = "MFA-IGCv3-Token"
  config = {
		"x509-cert-auth.canonical-dn-enabled"     = "false"
		"x509-cert-auth.extendedkeyusage"         = "1.3.6.1.5.5.7.3.2"
		"x509-cert-auth.serialnumber-hex-enabled" = "false"
		"x509-cert-auth.regular-expression"       = "(.*?)(?:$)"
		"x509-cert-auth.mapper-selection"         = "Username or Email"
		"x509-cert-auth.crl-relative-path"        = "crl.pem"
		"x509-cert-auth.crldp-checking-enabled"   = "true"
		"x509-cert-auth.mapping-source-selection" = "Subject's Alternative Name E-mail",
		"x509-cert-auth.timestamp-validation-enabled" = "true"
  }
}

resource "keycloak_authentication_subflow" "browser-conditional-otp" {
  realm_id          = var.keycloak_realm
  alias             = "Conditional OTP"
  parent_flow_alias = keycloak_authentication_flow.browser-x509-flow.alias
  authenticator     = "auth-x509-client-username-form"
  requirement       = "CONDITIONAL"
  depends_on        = [ keycloak_authentication_execution.browser-x509 ]
}

resource "keycloak_authentication_execution" "otp-user-configured" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_subflow.browser-conditional-otp.alias
  authenticator     = "conditional-user-configured"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution" "otp-conditional-form" {
  realm_id          = var.keycloak_realm
  parent_flow_alias = keycloak_authentication_subflow.browser-conditional-otp.alias
  authenticator     = "auth-otp-form"
  requirement       = "REQUIRED"
  depends_on        = [ keycloak_authentication_execution.otp-user-configured ]
}

################################
##  Référentiel utilisateurs  ##
################################

resource "keycloak_ldap_user_federation" "local_respository" {

  realm_id                        = var.keycloak_realm
  enabled  = true

  vendor         = "AD"
  edit_mode      = "UNSYNCED"
  import_enabled = true
  pagination     = true
  priority = 0

  name     = var.ldap_server_name

  username_ldap_attribute = "sAMAccountName"
  rdn_ldap_attribute      = "cn"
  uuid_ldap_attribute     = "objectGUID"
  user_object_classes     = [
    "person",
    "organizationalPerson",
    "user"
  ]
  connection_url  = var.keycloak_ldap_server_url
  bind_dn         = var.keycloak_ldap_bind_dn
  bind_credential = var.keycloak_ldap_bind_credential

  users_dn                = var.keycloak_ldap_users_dn
  
  search_scope            = "SUBTREE"

  custom_user_search_filter = ""

  connection_timeout = "5s"
  read_timeout       = "10s"

  start_tls = false
  trust_email = true

  sync_registrations = false
  
  validate_password_policy = false

  use_password_modify_extended_op = false
  use_truststore_spi = "ONLY_FOR_LDAPS"
  
  batch_size_for_sync             = 1000

  lifecycle {
    ignore_changes = [
      bind_credential
    ]
  }

}

resource "keycloak_ldap_role_mapper" "intra_cert_role_mapper" {
  realm_id                       = var.keycloak_realm
  ldap_user_federation_id        = keycloak_ldap_user_federation.local_respository.id
  name                           = var.keycloak_ldap_roles_mapper_name
  memberof_ldap_attribute        = "memberOf"
  membership_attribute_type      = "DN"
  membership_ldap_attribute      = "member"
  membership_user_ldap_attribute = "sAMAccountName"
  mode                           = "READ_ONLY"
  role_name_ldap_attribute       = "cn"
  role_object_classes            = [
    "group",
  ]
  ldap_roles_dn                  = var.keycloak_ldap_roles_mapper_dn
  roles_ldap_filter              = var.keycloak_ldap_roles_mapper_filter
  use_realm_roles_mapping        = true
  user_roles_retrieve_strategy   = "LOAD_ROLES_BY_MEMBER_ATTRIBUTE"
}

###################################
##  Generating AWS SAMLv2 Client ##
###################################

resource "keycloak_saml_client" "GCP_saml_client" {
  realm_id  = var.keycloak_realm
  client_id = "google.com"
  name      = "Google Cloud Platform"
  enabled   = true
  description = "Client SAML pour IdP GCP"

  encrypt_assertions      = false
  sign_documents          = true
  sign_assertions         = true
  include_authn_statement = true

  signature_algorithm = "RSA_SHA256"
  signature_key_name  = "KEY_ID"
  canonicalization_method = "EXCLUSIVE"

  full_scope_allowed          = false

  client_signature_required = false
  force_post_binding        = true
  front_channel_logout      = true

  base_url = "https://www.google.com/a/company.cloud/ServiceLogin?continue=https://console.cloud.google.com"

  force_name_id_format = true

  valid_redirect_uris = [ "https://www.google.com/*" ]
  
}
