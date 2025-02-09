{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.searx;
in {
  options.services.searx = {
    defaults.enable = mkEnableOption "Enable opinionated defaults.";
    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.defaults.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    # SSL CERT
    security.acme = mkIf cfg.reverseProxy.enable {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      searx = {
        redisCreateLocally = true;
        settings = {
          use_default_settings = true;

          general = {
            debug = false;
            instance_name = "kossLAN's SearXNG";
          };

          server = {
            port = 8888;
            bind_address = "127.0.0.1";
            secret_key = config.secrets.searx.privateKey;
            base_url = false;
            image_proxy = false;

            default_http_headers = {
              X-Content-Type-Options = "nosniff";
              X-XSS-Protection = "1; mode=block";
              X-Download-Options = "noopen";
              X-Robots-Tag = "noindex, nofollow";
              Referrer-Policy = "no-referrer";
            };
          };

          outgoing = {
            request_timeout = 2.0;
            pool_connections = 100;
            pool_maxsize = 10;
          };

          search = {
            safe_search = 2;
            autocomplete = "google";
            formats = ["html" "json"];
          };

          ui.static_use_hash = true;
        };
      };

      # NGINX Reverse Proxy
      nginx = mkIf cfg.reverseProxy.enable {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "search.${cfg.reverseProxy.domain}" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:8888/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_ssl_server_name on;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };
      };
    };
  };
}
