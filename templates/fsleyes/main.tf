terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.10"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22"
    }
  }
}

locals {
  username = data.coder_workspace.me.owner
  activeuser = "kasm-user"
}

data "coder_provisioner" "me" {
}

provider "docker" {
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch = data.coder_provisioner.me.arch
  os   = "linux"

  # login_bef      ore_ready     = false
    
  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    USER                  = "${data.coder_workspace.me.id}"
    KASM_USER             = "${local.username}"
    # HOME                  = "/home/${local.username}"
    KASM_VNC_PATH         = "/usr/share/kasmvnc"
    STARTUPDIR            = "/dockerstartup"    
    GIT_AUTHOR_NAME       = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME    = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL      = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL   = "${data.coder_workspace.me.owner_email}"
    VNC_PW                = "password"
  }
}

# Make button for VS Code server
resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "Code Editor"
  url          = "http://localhost:13337/?folder=/data"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

# Make button for VNC control of narcOS
resource "coder_app" "kasmvnc" {
  agent_id     = coder_agent.main.id
  slug         = "kasmvnc"
  display_name = "narcOS VNC"
  url          = "http://localhost:6901/?folder=/data"
  icon         = "https://avatars.githubusercontent.com/u/44181855?s=280&v=4"
  subdomain    = true
  share        = "owner"
  healthcheck {
    url       = "http://localhost:6901"
    interval  = 5
    threshold = 6
  }
}

# Make button for Jupyter Notebook
resource "coder_app" "jupyter" {
  agent_id     = coder_agent.main.id
  slug         = "jupyter"
  display_name = "JupyterLab"
  url          = "http://localhost:8887"
  icon         = "https://avatars.githubusercontent.com/u/7388996?s=200&v=4"
  subdomain    = true
  share        = "owner"
  healthcheck {
    url       = "http://localhost:8887/healthz"
    interval  = 5
    threshold = 10
  }
}

# Make a button for R studio
resource "coder_app" "rstudio" {
  agent_id      = coder_agent.main.id
  slug          = "rstudio"
  display_name  = "R Studio"
  icon          = "https://upload.wikimedia.org/wikipedia/commons/d/d0/RStudio_logo_flat.svg"
  url           = "http://localhost:8886"
  subdomain     = true
  share         = "owner"

  healthcheck {
    url       = "http://localhost:8886/healthz"
    interval  = 3
    threshold = 10
  }
}

# Make button for Filebrowser
resource "coder_app" "filebrowser" {
  agent_id     = coder_agent.main.id
  display_name = "File Browser"
  slug         = "filebrowser"
  url          = "http://localhost:13339"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/database.svg"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13339/healthz"
    interval  = 3
    threshold = 10
  }
}


resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}


resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.id}"
  build {
    path = "build/."
    build_args = {
      USER = "${local.username}"
      KASM_USER = "${local.username}"
      HOME = "/home/${local.username}"
    }
  }


  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "build/*") : filesha1(f)]))
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  # Hostname makes the shell more user friendly: coder@my-workspace:~$
  hostname = data.coder_workspace.me.name
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}", "KASM_USER=${local.username}"]
 
  # cap_add = ["SYS_ADMIN"]

  
  memory = 61440 # 60 GB ram
  cpu_set = "0-12" # 12 cores
  
  # Adjust shared memory size
  shm_size = 8096  # Set shared memory size to 4GB


  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/data/s3"
    host_path = "/home/${local.username}/s3"
  }

  volumes {
    container_path = "/neurodesktop-storage"
    host_path = "/home/${local.username}/s3/neurodesktop-storage"
  }

  volumes {
    container_path = "/home/${local.username}"
    host_path = "/home/${local.username}/s3/home"
  }

  volumes {
    container_path = "/data/narcserver"
    host_path      = "/mnt/narcserver"
    # volume_name    = docker_volume.home_volume.name
    # read_only      = false
  }

  volumes {
    container_path = "/data/narcserver_mri"
    host_path = "/mnt/narcserver_mri"
  }

  volumes {
    container_path = "/data/jdrive"
    host_path = "/mnt/jdrive/psych/NARC"
  }



  # volumes {
  #   container_path = "/media/${local.username}/datalad"
  #   host_path = "/mnt/minio/hdd8tb/disk1/ntfs"
  # }

  # volumes {
  #   container_path = "/media/${local.username}/narcbox"
  #   host_path = "/home/narc/mounts/s3/projects"
  # }

  # devices {
  #   host_path      = "/dev/fuse"
  #   container_path = "/dev/fuse"
  # }
  
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}