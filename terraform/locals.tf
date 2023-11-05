locals {
  application_stages = ["one", "two", "three"]

  application_specific_variables = flatten([
    for app_key, app_value in var.application_settings : [
      for stage in local.application_stages : {
        application_subdomain    = app_key
        stage_name               = stage
        create_application_stage = "${(stage == "one" && app_value.stage_one_image != "") || (stage == "two" && app_value.stage_two_image != "") || (stage == "three" && app_value.stage_three_image != "") ? "Deployed" : "        " }"
        image                    = "${stage == "one" ? app_value.stage_one_image : stage == "two" ? app_value.stage_two_image : stage == "three" ? app_value.stage_three_image : ""}"
      }
    ]
  ])
}
