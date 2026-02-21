resource "vault_raft_autopilot" "autopilot" {
  cleanup_dead_servers               = true
  dead_server_last_contact_threshold = "1m0s"
  disable_upgrade_migration          = false
  last_contact_threshold             = "10s"
  max_trailing_logs                  = 1000
  min_quorum                         = 3
  server_stabilization_time          = "10s"
}
