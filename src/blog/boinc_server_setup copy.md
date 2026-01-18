---
layout: blog.html
title: BOINC Guide - Hello World for urban@home
description: BOINC server setup guide for urban@home project with how to get started with a boilerplate project server. This guide covers installation, configuration, and deployment steps for setting up a BOINC server.
date: 2026-01-15
tags: post
summary: "This page walkthrough of how I plan to set up my own BOINC distributed computing server from scratch. This is the same server setup that is used for projects like SETI@home and Einstein@Home. This guide breaks down the official BOINC cookbook into 15 digestible phases using Claude Opus 4.5, covering everything from VM setup to running your first distributed job. I plan to use this as a way to set up my own BOINC project server. This is for my urban@home project which aims to explore large-scale urban science simulations."
---

# BOINC Server Setup Guide
### by: Adam Socki
This guide provides step-by-step instructions for setting up a BOINC server for my [urban@home project](http://adamsocki.github.io/_projects/urban_at_home_proj/). BOINC (Berkeley Open Infrastructure for Network Computing). For those unfamiliar, BOINC is an open-source platform for volunteer computing that allows researchers to deploy computational projects to a distributed network of volunteer computers. 

## My History with BOINC
I first encountered BOINC in 1999/2000 when I participated in the SETI@home project using my very first computer, an original iMac G3. I remember watching the screensaver for hours at a time trying to understand what it was doing by trying to decipher the signals being rendered on the screen. 

I have been participating on and off in various BOINC projects over the years. Recently, I decided to explore setting up my own BOINC server for the urban@home project, which focuses on developing distributed simulations of various urban science topics with the goal of utilizing volunteer computing to run large-scale simulations.

I'm documenting my journey of setting up a BOINC server for urban@home in this blog post.

## How this Guide was Created
This guide was created by following the [BOINC cookbook server setup](https://github.com/BOINC/boinc/wiki/Create-a-BOINC-server-(cookbook)) documentation and reinterpreting it using Opus 4.5. One of the challenges I've faced is that the official documentation can be quite dense and difficult to follow. By using Opus, I was hoping to break down the steps into more manageable pieces and provide additional context and explanations where needed.


## Prompts Used
Here are some of the prompts I used to generate this guide:

> "I’m trying to implement a BOINC server, but I’m having a hard time following this tutorial. Could you  break it down for me with like every step that I need to take to do from beginning to end https://github.com/BOINC/boinc/wiki/Create-a-BOINC-server-(cookbook) tThe goal here is to create my own distributed project that I’ll eventually deploy, but I want to like understand how it all works first."

This prompt generated the initial outline and structure of the guide with very detailed steps but lacked context to understand why each step was necessary or how it fit into the overall BOINC server architecture.

I followed up with the following prompt:

> "Can you also just provide like kind of a narrative written description of what it is that we’re doing and what it is that we will eventually produce at the end? I guess I’m just kind of confused like, how does this relate to actual BOINC projects that I contribute to like Einstein at home?"



I then asked to combine the two outputs into a single cohesive guide with both detailed steps and contextual explanations. This is the result:

<div class="section-divider">▼ The Guide ▼</div>

# Building Your Own BOINC Server: A Complete Guide

## The Big Picture: What Are We Actually Building?

When you contribute to projects like Einstein@Home, SETI@Home, or Rosetta@home, you're running the **BOINC client**. It downloads work, crunches numbers, and uploads results. But someone had to build the infrastructure on the other end—the system that creates the work, distributes it to thousands of volunteers, collects the results, and processes them into scientific findings.

**That's what you're building in this guide: the server side of a BOINC project.**

### The Two Halves of BOINC

BOINC is really two pieces of software that talk to each other over the internet:

| Component | What It Does | Who Runs It |
|-----------|--------------|-------------|
| **Client** | Downloads work, runs computations, uploads results | Volunteers (you already know this part) |
| **Server** | Creates work, distributes it, validates results, awards credit | Project operators (what you're building) |

Every BOINC project runs their own server infrastructure. Einstein@Home has theirs at UW-Milwaukee. World Community Grid runs theirs at IBM. When you finish this guide, you'll have your own—smaller, but functionally identical.

### The Server's Job: A Work Coordinator

Think of the BOINC server as a job shop coordinator managing a massive distributed workforce. Here's the lifecycle of work in a BOINC project:

1. **You have a computation problem.** Maybe analyzing gravitational wave data, folding proteins, or (in your case potentially) running transportation simulations. The key is that the problem can be split into many independent chunks.

2. **You package your analysis code as a "BOINC app."** This is a compiled executable that reads an input file, does computation, and writes an output file. The tutorial uses a toy example called "uppercase" that converts text to uppercase.

3. **You create "work units."** Each work unit is an input file plus metadata saying "run this app on this input." In Einstein@Home, each work unit might be "analyze this 30-second chunk of LIGO data."

4. **The scheduler hands out work.** When a volunteer's client connects and says "I have an Intel CPU running Linux, give me work," the scheduler finds appropriate work units and sends them.

5. **Results come back.** The client runs your app, produces output, and uploads it.

6. **Validation happens.** BOINC typically sends the same work to multiple volunteers. The validator compares results—if they match, great. If not, send to more volunteers until you get consensus. This protects against errors and cheating.

7. **Assimilation processes valid results.** Once validated, the assimilator does something with the output—stores it in a database, feeds it to the next analysis stage, etc.

8. **Credit gets awarded.** Volunteers receive computation credit, feeding the leaderboards and gamification that keeps people engaged.

### What You'll Have at the End

When you complete this guide, you'll have a fully functional BOINC project with:

- A **public website** where volunteers can create accounts and see statistics
- An **admin interface** for managing applications and monitoring the system
- A **scheduler** that distributes work to any BOINC client that connects
- **Daemon processes** (feeder, transitioner, validator, assimilator, file deleter) that manage the job lifecycle
- A **sample application** that actually runs on volunteer machines

You could literally tell someone on another computer to install BOINC, enter your server's URL, and start contributing—just like Einstein@Home, but with your workload.

---

## Phase 1: Setting Up the Virtual Machine

### Why a VM?

We're using VirtualBox to create an isolated Ubuntu environment. This approach has several advantages:

- **Snapshots**: You can save the VM state at any point and roll back if something goes wrong
- **Portability**: You can move the VM image to different hardware later
- **Isolation**: Your BOINC server won't interfere with your main system
- **Reproducibility**: You can delete everything and start fresh easily

You could do all of this on bare metal (a real server), and eventually you'd want to for a production deployment. But for learning, a VM is ideal.

### Step 1.1: Install VirtualBox

```
Download VirtualBox 7.0 from https://virtualbox.org
Also download the Guest Additions ISO (improves VM performance)
Install VirtualBox on your host machine (Windows, Mac, or Linux)
```

### Step 1.2: Get Ubuntu

```
Download Ubuntu 22.04 LTS ISO from https://ubuntu.com/download/desktop
(Alternative: Xubuntu uses less RAM if your machine is constrained)
```

### Step 1.3: Create the Virtual Machine

Open VirtualBox and click "New" to create a VM:

| Setting | Value | Why |
|---------|-------|-----|
| Name | `BOINC` | Only alphanumerics, `-` and `.` allowed (becomes hostname) |
| Type | Linux | |
| Version | Ubuntu (64-bit) | |
| RAM | 4096 MB minimum | BOINC daemons + MySQL + Apache need memory |
| CPU | 1 core minimum | More helps during compilation |
| Disk | 25 GB minimum | Project files, database, logs accumulate |

In the "Unattended Guest OS Install Setup" dialog:
- Username: `boincadm` (this will be your main account)
- Password: choose something secure
- Check "Guest Additions" to install automatically

### Step 1.4: Start the VM

Click "Start" in VirtualBox. The VM will boot from the Ubuntu ISO and install automatically. This takes several minutes—go get coffee.

Once complete, you'll see the Ubuntu desktop with a login screen.

---

## Phase 2: Network Configuration

### Why This Matters

By default, VirtualBox uses NAT networking, which means your VM can access the internet but nothing can access the VM. For a BOINC server, you need the opposite—BOINC clients need to reach your server to get work.

Bridged networking puts your VM directly on your local network with its own IP address, as if it were a separate physical computer.

### Step 2.1: Shut Down the VM

Close the VM window and select "Power Off" (not "Save State").

### Step 2.2: Configure Bridged Networking

In VirtualBox Manager:
1. Right-click your VM → Settings
2. Click "Network"
3. Change "Attached to:" from `NAT` to `Bridged Adapter`
4. Click OK

### Step 2.3: Start VM and Get IP Address

Start the VM, log in as `boincadm`, and open a terminal (click the grid icon at bottom-left, search for "Terminal").

```bash
ip address
```

Look for output like this:
```
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
    inet 192.168.1.42/24 ...
```

**Write down the IP address** (e.g., `192.168.1.42`). You'll use this throughout the rest of the setup. This IP is accessible from your host machine and other computers on your LAN.

---

## Phase 3: User Account Setup

### The boincadm Account

All BOINC project operations run under the `boincadm` account you created during installation. This account needs sudo (administrator) privileges to install packages and configure services.

### Step 3.1: Verify Sudo Access

```bash
sudo whoami
```

If this prints `root`, you're good. If not:

```bash
su
# Enter root password
adduser boincadm sudo
exit
# Log out and back in for changes to take effect
```

### Step 3.2: Shell Conveniences (Optional but Recommended)

Add some safety aliases to prevent accidental file deletion:

```bash
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias cp='cp -i'" >> ~/.bashrc
echo "alias mv='mv -i'" >> ~/.bashrc
source ~/.bashrc
```

### Step 3.3: Disable Screen Blanking

Go to Settings → Power → Screen Blank → Never

This prevents the screen from going dark while you're working, which can be annoying in a VM.

### Step 3.4: Open This Guide in Firefox

Open Firefox inside the VM and navigate to this guide (or copy it in). That way you can copy-paste commands directly.

---

## Phase 4: Installing Required Packages

### What We're Installing and Why

A BOINC server requires several software components:

| Package | Purpose |
|---------|---------|
| **git** | Download BOINC source code |
| **mysql-server** | Database for storing users, work units, results, etc. |
| **apache2** | Web server for the project website and scheduler |
| **PHP** | Dynamic web pages (account creation, stats, admin interface) |
| **autoconf, libtool, pkg-config** | Build tools to compile BOINC |
| **libcurl, libmysqlclient** | Libraries BOINC needs |
| **python3, pip** | Scripts and database access |

### Step 4.1: Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
sudo snap refresh
```

### Step 4.2: Install Core Dependencies

Run each of these commands:

```bash
# Version control
sudo apt-get -y install git

# Database server
sudo apt-get -y install mysql-server
sudo apt-get -y install libmysqlclient-dev

# Note: If MySQL packages fail, use MariaDB instead:
# sudo apt-get -y install default-mysql-server
# sudo apt-get -y install libmariadbclient-dev
# sudo apt-get -y install libmariadb-dev

# Web server
sudo apt-get -y install apache2

# Build tools
sudo apt-get -y install autoconf
sudo apt-get -y install pkg-config
sudo apt-get -y install libtool

# Required libraries
sudo apt-get -y install libcurl4-openssl-dev

# Python
sudo apt-get -y install python3-pip
sudo apt-get -y install python-is-python3

# PHP and extensions
sudo apt-get -y install libapache2-mod-php
sudo apt-get -y install php-mysql
sudo apt-get -y install php-cli
sudo apt-get -y install php-gd
sudo apt-get -y install php-xml
```

### Step 4.3: Install Python MySQL Connector

```bash
sudo pip install -U pip
pip install mysqlclient
```

This lets Python scripts (including BOINC's backend tools) talk to the MySQL database.

---

## Phase 5: Configure MySQL

### Why MySQL?

BOINC stores everything in a relational database: user accounts, host information, work units, results, credit totals, teams, etc. MySQL (or MariaDB) handles this. Each BOINC project gets its own database.

### Step 5.1: Secure the MySQL Installation

```bash
sudo mysql_secure_installation
```

Answer the prompts:

| Prompt | Answer | Why |
|--------|--------|-----|
| Validate passwords? | yes | Good practice |
| Password strength | 0 (low) | Fine for development |
| Set root password | `foobar99` | Or whatever you prefer—remember it! |
| Remove anonymous users? | yes | Security |
| Disallow remote root? | yes | Security |
| Remove test database? | yes | Cleanup |
| Reload privileges? | yes | Apply changes |

### Step 5.2: Create the boincadm MySQL User

The BOINC daemons run as the `boincadm` Linux user, so we need a MySQL user with the same name:

```bash
sudo mysql
```

In the MySQL prompt:
```sql
CREATE USER 'boincadm'@'localhost' IDENTIFIED BY 'foobar99';
GRANT ALL ON *.* TO 'boincadm'@'localhost';
exit
```

This creates a MySQL user that can create databases, which is needed when we create the BOINC project.

### Step 5.3: Test the Connection

```bash
mysql -u boincadm -p
# Enter password: foobar99
```

In the MySQL prompt:
```sql
show databases;
exit
```

You should see a list of system databases. If this works, MySQL is ready.

---

## Phase 6: Configure Apache

### The Two-User Problem

A BOINC project has two types of software running:

1. **Web server components** (scheduler, file upload handler, PHP pages) — these run under the Apache user account, which is `www-data` on Ubuntu

2. **Daemon processes** (feeder, transitioner, validator, assimilator) — these run under your `boincadm` account

Both need to read and write the same files (work units, results, etc.). The solution is to put both users in the same Unix group.

### Step 6.1: Add www-data to the boincadm Group

```bash
sudo usermod -a -G boincadm www-data
```

Now the `www-data` user (Apache) is a member of the `boincadm` group and can access files owned by that group.

### Step 6.2: Enable CGI

The BOINC scheduler runs as a CGI program—Apache executes it when clients request work. We need to enable this:

```bash
sudo a2enmod cgi
sudo systemctl restart apache2
```

### Step 6.3: Verify Apache is Running

Open Firefox in the VM and visit `http://localhost`

You should see the "Apache2 Ubuntu Default Page". If you see this, Apache is working.

---

## Phase 7: Download and Build BOINC

### Getting the Source Code

BOINC is open source, hosted on GitHub. We'll clone the repository and build the server components.

### Step 7.1: Clone the BOINC Repository

```bash
cd ~
git clone https://github.com/BOINC/boinc.git
```

This downloads the complete BOINC source code to `~/boinc/`.

### Step 7.2: Build the Server Software

```bash
cd boinc
./_autosetup
./configure --disable-client --disable-manager --enable-apps
make
```

**What these commands do:**

| Command | Purpose |
|---------|---------|
| `./_autosetup` | Generates the configure script from templates |
| `./configure --disable-client --disable-manager --enable-apps` | Prepares the build, excluding the client/GUI (we only need server), including sample apps |
| `make` | Compiles everything |

**Note:** You'll see lots of compiler warnings. Ignore them—warnings are not errors. The build takes several minutes.

### What Got Built?

After compilation, you have:

- `~/boinc/sched/` — Scheduler, file upload handler
- `~/boinc/tools/` — Project creation and management scripts
- `~/boinc/apps/` — Sample applications including "uppercase"
- `~/boinc/lib/` — Libraries for building BOINC apps
- `~/boinc/db/` — Database utilities

---

## Phase 8: Create Your BOINC Project

### What make_project Does

The `make_project` script is BOINC's project creation wizard. It:

1. Creates a MySQL database for your project
2. Creates a directory tree with all the files your project needs
3. Generates configuration files
4. Sets up the web interface
5. Creates encryption keys for secure communication

### Step 8.1: Run make_project

```bash
cd ~/boinc/tools
./make_project --db_passwd foobar99 --url_base http://YOUR_IP_ADDRESS test
```

**Replace `YOUR_IP_ADDRESS` with the IP you noted in Phase 2** (e.g., `192.168.1.42`).

The `test` at the end is your project's short name. It becomes the database name and URL path.

You'll see output like:
```
Creating project 'test' (short name 'test'):
   PROJECT_ROOT = /home/boincadm/projects/test/
   PROJECT_HOST = BOINC
       URL_BASE = http://192.168.1.42/
  HTML_USER_URL = http://192.168.1.42/test/
   HTML_OPS_URL = http://192.168.1.42/test_ops/
        KEY_DIR = /home/boincadm/projects/test/keys/
        DB_NAME = test
        DB_HOST = 

Continue? [Y/n] 
```

Type `y` and press Enter.

### Step 8.2: Configure Apache for the Project

The project created an Apache configuration file. We need to enable it:

```bash
cd ~/projects/test
sudo cp test.httpd.conf /etc/apache2/sites-enabled/
sudo apache2ctl restart
```

This tells Apache how to serve your project's web pages and where to find the scheduler CGI.

### Step 8.3: Set Up the Cron Job

BOINC needs a maintenance script to run every 5 minutes. This handles things like retrying failed tasks, cleaning up old files, etc.

```bash
crontab -e
```

If asked which editor to use, choose `nano` (easiest).

Add this line at the bottom (it's all one line):

```
0,5,10,15,20,25,30,35,40,45,50,55 * * * * cd /home/boincadm/projects/test; /home/boincadm/projects/test/bin/start --cron
```

Save and exit (in nano: Ctrl+O, Enter, Ctrl+X).

### Step 8.4: Initialize the Database

```bash
cd ~/projects/test
bin/xadd
```

This populates the database with initial data (platforms, app types, etc.).

### Step 8.5: Set Up the Admin Interface

The admin interface lets you manage applications, view server status, and debug problems. It needs password protection:

```bash
cd ~/projects/test/html/ops
htpasswd -c .htpasswd boincadm
# Enter a password when prompted (can be different from your login password)
```

Test it by visiting `http://YOUR_IP_ADDRESS/test_ops` in Firefox. Enter username `boincadm` and the password you just set.

### Step 8.6: Customize Project Information

Edit the project configuration to set your project name:

```bash
cd ~/projects/test/html/project
nano project.inc
```

Find and change:
- `PROJECT` → Your project's display name (e.g., "My BOINC Project")
- `COPYRIGHT_HOLDER` → Your name or organization

Save and exit.

### Step 8.7: Start the Project

```bash
cd ~/projects/test
bin/start
```

This launches all the daemon processes that make your project run.

### Step 8.8: Verify the Website

Visit `http://YOUR_IP_ADDRESS/test/` in Firefox.

You should see your project's public website! It will have:
- A welcome message with your project name
- Links to create an account, view stats, etc.
- News section (empty for now)

**Congratulations!** You now have a running BOINC project. It just doesn't have any work yet.

---

## Phase 9: Create a User Account

### Becoming a Volunteer on Your Own Project

To test the full workflow, you'll create an account on your project and attach a BOINC client to it.

### Step 9.1: Register on Your Project

1. Go to `http://YOUR_IP_ADDRESS/test/`
2. Click "Join" or "Create Account"
3. Enter:
   - Name (display name for leaderboards)
   - Email address (doesn't need to be real for testing)
   - Password

You now have a volunteer account on your project!

---

## Phase 10: Install and Configure the BOINC Client

### Testing the Full Loop

To verify everything works, we'll install the BOINC client on the same VM and have it request work from our server. In a real deployment, clients would be on completely different machines.

### Step 10.1: Install the BOINC Client

```bash
sudo add-apt-repository --remove ppa:costamagnagianfranco/boinc
sudo apt-get install boinc
```

### Step 10.2: Fix Permissions (Bug Workaround)

There's a bug in the Ubuntu BOINC package that requires this fix:

```bash
sudo chown -R boincadm /var/lib/boinc-client
```

### Step 10.3: Run the Client and Manager

You need two terminal windows:

**Terminal 1 — Run the BOINC client:**
```bash
cd ~
boinc
```

This starts the BOINC core client. Leave this terminal open.

**Terminal 2 — Run the BOINC Manager:**
```bash
boincmgr
```

This opens the graphical BOINC Manager that you're familiar with from volunteering.

### Step 10.4: Attach to Your Project

The BOINC Manager will show an "Add Project" dialog:

1. In the URL field, enter: `http://YOUR_IP_ADDRESS/test/`
2. Click Next
3. Select "Yes, I have an account"
4. Enter the email and password you created in Phase 9

### Step 10.5: Verify the Connection

1. In BOINC Manager, go to View → Advanced View
2. Click the "Projects" tab — your project should appear
3. Go to Tools → Event Log

In the Event Log, you'll see the client communicating with your server. It will say something like "Scheduler request completed" but "no work available".

**This is expected!** We haven't created an application or submitted any work yet. The client has nothing to do.

---

## Phase 11: Create an Application

### What is a BOINC Application?

A BOINC application is a program that:
1. Reads one or more input files
2. Performs computation
3. Writes one or more output files
4. Reports progress and CPU time to the BOINC client

The BOINC infrastructure handles everything else: distributing the app to volunteers, sending input files, collecting output files, validating results, etc.

### The "Uppercase" Example App

BOINC includes a trivial example app called "uppercase" that:
- Reads a file named `in`
- Converts all text to uppercase
- Writes the result to a file named `out`
- Wastes 20 seconds of CPU time (to simulate real computation)

We'll use this to test our infrastructure.

### Step 11.1: Register the Application

1. Go to `http://YOUR_IP_ADDRESS/test_ops` (admin interface)
2. Click "Manage applications"
3. Add a new application:
   - Name: `uppercase`
   - Description: `Uppercase` (or whatever you want)

This creates a database record for the application.

### Step 11.2: Install Input/Output Templates

BOINC uses XML template files to describe what input and output files an application expects. Copy the templates for the uppercase app:

```bash
cd ~/projects/test
cp ~/boinc/apps/uppercase_in templates/
cp ~/boinc/apps/uppercase_out templates/
```

**What's in these templates?**

`uppercase_in` describes the input file:
- One input file named "in"
- Downloaded from the server

`uppercase_out` describes the output file:
- One output file named "out"
- Uploaded back to the server

### Step 11.3: Configure Validator and Assimilator Daemons

Each application needs two daemon processes:

| Daemon | Purpose |
|--------|---------|
| **Validator** | Checks if results are correct (compares results from multiple volunteers) |
| **Assimilator** | Processes validated results (stores them, feeds them to analysis, etc.) |

Edit the project configuration:

```bash
nano ~/projects/test/config.xml
```

Find the `<daemons>` section. Add these two daemon entries inside it:

```xml
      <daemon>
          <cmd>sample_trivial_validator --app uppercase</cmd>
      </daemon>
      <daemon>
          <cmd>sample_assimilator --app uppercase</cmd>
      </daemon>
```

**What do these do?**

- `sample_trivial_validator` — Accepts all results as valid (no actual checking). Fine for testing, but real projects compare results from multiple volunteers.

- `sample_assimilator` — Moves validated output files to `~/projects/test/sample_results/`. A real project would do something meaningful with the data.

Save and exit the file.

---

## Phase 12: Create an App Version

### Applications vs. App Versions

In BOINC terminology:
- **Application** — An abstract concept (e.g., "uppercase")
- **App Version** — A specific compiled executable for a specific platform (e.g., "uppercase 1.0 for Linux x86_64")

You need an app version for each platform you want to support. For this tutorial, we'll just create a Linux version.

### Step 12.1: Create the Directory Structure

BOINC expects app versions in a specific directory layout:

```
projects/test/apps/
    uppercase/           ← application name
        1.0/             ← version number
            x86_64-pc-linux-gnu/   ← platform
                uppercase          ← the executable
                version.xml        ← metadata
```

Create this structure:

```bash
cd ~/projects/test/apps
mkdir -p uppercase/1.0/x86_64-pc-linux-gnu
```

### Step 12.2: Copy the Executable and Metadata

```bash
cd ~/projects/test/apps/uppercase/1.0/x86_64-pc-linux-gnu
cp ~/boinc/apps/uppercase .
cp ~/boinc/apps/version.xml .
```

The `uppercase` file is the compiled executable we built earlier. The `version.xml` file describes it to BOINC.

### Step 12.3: Register the App Version

```bash
cd ~/projects/test
bin/update_versions
```

This scans the `apps/` directory and registers any new app versions in the database.

You'll see warnings about code signing:
```
Warning: no code signing key found
```

Ignore these warnings and type `Y` when prompted. Code signing is important for production (prevents malicious code), but we can skip it for testing.

### Step 12.4: Restart the Project

The daemons need to pick up the new configuration:

```bash
cd ~/projects/test
bin/stop
bin/start
```

**Your project now has a working application!** Clients can download the uppercase app and run it.

---

## Phase 13: Submit and Run a Job

### Creating Work

Now we'll create an actual work unit and watch it flow through the system.

### Step 13.1: Create an Input File

```bash
cd ~/projects/test
echo "Hello World! This is a TEST of my BOINC project. Let's see if it works correctly." > infile
```

### Step 13.2: Submit the Job

```bash
bin/submit_job uppercase infile
```

This creates a work unit using the "uppercase" app with "infile" as input.

The command prints a job name like `uppercase_1_0`. **Write this down** — you'll need it to check the result.

**What just happened?**
1. The input file was copied to the project's download directory
2. A database record was created for the work unit
3. The scheduler can now send this job to any client that asks for work

### Step 13.3: Tell the Client to Check for Work

Go to BOINC Manager:
1. Click the "Projects" tab
2. Select your project
3. Click "Update"

This tells the client to immediately contact the server rather than waiting for the next scheduled check.

### Step 13.4: Watch the Job Run

Go to the "Tasks" tab in BOINC Manager. You should see a task appear and start running!

Watch the Event Log (Tools → Event Log) to see the detailed communication:
- Client downloads the app version
- Client downloads the input file
- Task starts running
- Task completes
- Client uploads the result

The uppercase app runs for about 20 seconds.

### Step 13.5: Check the Result

Once the task shows "Ready to report" in BOINC Manager, click "Update" again to upload the result.

Then check the result from the command line:

```bash
cd ~/projects/test
bin/query_job uppercase_1_0
```

Replace `uppercase_1_0` with the actual job name from step 13.2.

The output will show:
- Job status: "done"
- The output file contents (your text in UPPERCASE)

**Congratulations!** You've completed the full BOINC workflow:
1. Created an application
2. Submitted a job
3. A client downloaded and ran it
4. The result was validated and processed

---

## Phase 14: Understanding Log Files

### Where to Look When Things Go Wrong

BOINC projects generate extensive logs. Knowing where to look is essential for debugging.

### Project Daemon Logs

Location: `~/projects/test/log_BOINC/`

| Log File | What It Contains |
|----------|------------------|
| `feeder.log` | Shared memory feeder (prepares work for scheduler) |
| `transitioner.log` | State machine for work units (new → in progress → done) |
| `scheduler.log` | Job dispatcher (handles client requests) |
| `file_upload_handler.log` | Receives uploaded result files |
| `sample_trivial_validator.log` | Result validation |
| `sample_assimilator.log` | Result processing |
| `file_deleter.log` | Cleans up old files |

To view a log:
```bash
tail -f ~/projects/test/log_BOINC/scheduler.log
```

Look for lines containing "Error" or "Warning".

### Apache/PHP Logs

Location: `/var/log/apache2/`

```bash
sudo tail -f /var/log/apache2/error.log
```

This shows errors from the web interface (PHP errors, scheduler crashes, etc.).

### Client Logs

If you're debugging client-side issues, look at the Event Log in BOINC Manager, or:
```bash
cat ~/BOINC/boinc.log
```

---

## Phase 15: Project Control Commands

### Managing Your Project

These commands control your BOINC project:

```bash
cd ~/projects/test

# Start all daemons
bin/start

# Stop all daemons  
bin/stop

# Check status of all daemons
bin/status
```

### When Stopped vs. Running

| Project State | Website | Scheduler | Work Distribution |
|---------------|---------|-----------|-------------------|
| **Stopped** | Works | Doesn't respond | No jobs sent or received |
| **Running** | Works | Active | Jobs distributed and collected |

You might stop the project to do maintenance, upgrade software, or fix problems.

### Deleting a Project (If Needed)

If you want to start over completely:

```bash
# Drop the database
mysql -u boincadm -p
DROP DATABASE test;
exit

# Remove project files
cd ~/projects
rm -rf test

# Remove Apache config
sudo rm /etc/apache2/sites-enabled/test.httpd.conf
sudo apache2ctl restart

# Remove cron job
crontab -e
# Delete the line for this project
```

---

## Quick Reference

### Key Paths

| What | Path |
|------|------|
| BOINC source code | `~/boinc/` |
| Your project | `~/projects/test/` |
| Project config | `~/projects/test/config.xml` |
| App templates | `~/projects/test/templates/` |
| App versions | `~/projects/test/apps/` |
| Log files | `~/projects/test/log_BOINC/` |
| Public web files | `~/projects/test/html/user/` |
| Admin web files | `~/projects/test/html/ops/` |
| Project settings | `~/projects/test/html/project/project.inc` |
| Results (sample assimilator) | `~/projects/test/sample_results/` |

### Key URLs

| What | URL |
|------|-----|
| Public website | `http://YOUR_IP/test/` |
| Admin interface | `http://YOUR_IP/test_ops/` |
| Scheduler | `http://YOUR_IP/test_cgi/cgi` |

### Key Commands

```bash
# Project control
cd ~/projects/test
bin/start          # Start project
bin/stop           # Stop project
bin/status         # Check daemon status

# Job management
bin/submit_job uppercase inputfile   # Submit a job
bin/query_job jobname                # Check job status

# App management
bin/update_versions   # Register new app versions

# Database
bin/xadd              # Initialize database
```

---

## What's Next: From Tutorial to Real Project

This tutorial gives you a working skeleton. Here's what you'd need to do for a real deployment:

### 1. Replace the Toy App with Real Science

Instead of "uppercase", compile your actual analysis code against the BOINC libraries. Your app needs to:
- Use the BOINC API for checkpointing (save state so jobs can resume if interrupted)
- Report progress to the client
- Handle input/output files correctly

See: https://github.com/BOINC/boinc/wiki/AppIntro

### 2. Create Multi-Platform App Versions

The tutorial only makes a Linux version. Most volunteers run Windows or Mac. You'd need to:
- Cross-compile or build natively on each platform
- Create app version directories for `windows_x86_64`, `x86_64-apple-darwin`, etc.
- Test on each platform

### 3. Build Work Generators

The tutorial manually submits one job. Real projects continuously generate thousands of jobs. You'd write a work generator daemon that:
- Pulls from a queue of unprocessed data
- Creates work units automatically
- Manages how much work is available

See: https://github.com/BOINC/boinc/wiki/JobSubmission

### 4. Write Real Validators and Assimilators

The tutorial uses trivial versions. Real projects need:
- **Validator**: Compare results from multiple volunteers, detect errors and cheating
- **Assimilator**: Process results meaningfully (store in database, feed to analysis, etc.)

See: https://github.com/BOINC/boinc/wiki/BackendPrograms

### 5. Production Infrastructure

For public deployment, you need:
- A server visible on the internet (not just your LAN)
- A domain name
- SSL certificate (HTTPS)
- Proper backups
- Monitoring and alerting

### 6. Recruit Volunteers

Either publicize your project directly, or register with Science United so volunteers can discover you.

---

## Relevance to Transportation Planning

You mentioned interest in distributed computing for urban science research. Here's how BOINC could apply:

### Potential Use Cases

- **Scenario Analysis**: Run thousands of what-if scenarios for regional plans
- **Sensitivity Testing**: Explore parameter spaces in travel demand models
- **Microsimulation**: Distribute traffic microsimulation across many time periods or seed variations
- **Calibration**: Run many calibration iterations in parallel

### Challenges

1. **Proprietary Tools**: Many transportation models use commercial software (TransCAD, CUBE, VISUM) that can't be distributed to volunteers. You'd need open-source alternatives or custom code.

2. **Data Sensitivity**: Transportation data often includes sensitive information. You'd need to anonymize carefully.

3. **Volunteer Interest**: BOINC projects thrive when people feel connected to the mission. "Help understand urban mobility" could work, especially with local volunteers.

4. **Job Granularity**: BOINC works best when jobs take minutes to hours, not days. You'd need to decompose your analysis appropriately.

### A Hybrid Approach

Rather than pure volunteer computing, you might consider:
- Use BOINC infrastructure but limit it to known machines (a research cluster, university lab computers, colleagues' idle workstations)
- This gives you the distributed computing benefits without needing to package everything for unknown volunteers

---

## Getting Help

If you run into problems:

1. **BOINC Projects Email List**: boinc_projects@ssl.berkeley.edu
   Subscribe at: https://groups.google.com/a/ssl.berkeley.edu/g/boinc_projects

2. **GitHub Issues**: https://github.com/BOINC/boinc/issues

3. **BOINC Wiki**: https://github.com/BOINC/boinc/wiki
   Extensive documentation on all aspects of BOINC

---

*Guide created based on the official BOINC cookbook at https://github.com/BOINC/boinc/wiki/Create-a-BOINC-server-(cookbook)*
