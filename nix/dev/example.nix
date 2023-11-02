_: {
  perSystem = {self', ...}: {
    config.process-compose = {
      dev.settings.processes = {
        calc = {
          depends_on = {
            nats-server.condition = "process_healthy";
            nsc-push.condition = "process_completed_successfully";
          };
          environment = {
            # force nats context lookup to happen inside .data
            XDG_CONFIG_HOME = "$PRJ_DATA_DIR";
          };
          command = "${self'.packages.example}/bin/calc run --context example-service --port 8222";
        };
      };
    };
  };
}
