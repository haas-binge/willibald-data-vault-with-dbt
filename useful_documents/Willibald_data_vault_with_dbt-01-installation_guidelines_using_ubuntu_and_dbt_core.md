# Willibald data vault with dbt 01 installation guidelines using ubuntu and dbt-core

For an overview of all the available tutorials and documents, go to [README](../README.md).

Within this document we will try to describe every step necessary to fully install 
the Willibald on dbt implementation, trying not to assume any prior knowledge.
You don't need to know anything about Python, dbt or data vault.
To have a completely clean environment for this setup, we used a virtual machine with Ubuntu 22.04.

Our host machine is Windows (You will need Windows 10 64Bit Professional Edition at least), so we used Hyper V Manager to create the virtual machine.

Open Hyper-V-Manager/Action/create new virtual machine --> Choose Ubuntu (newest LTS)


## Basic installations
First of all you need to install some programms on the virtual machine. Start the terminal to do this.

- python should already be available  
    ```bash
        # Update the package list
        sudo apt update
        
        # check the installed version
        python3 --version
        # in my ubuntu version it showed: Python 3.10.12

        # Install Python in case it is not already available   
        sudo apt install python3

    ```

- code editor

  You need to decide on the code editor of your joice. We are using visual studio code.

    ```bash
        # Install the required dependencies for VS Code
        sudo apt install software-properties-common apt-transport-https wget

        # Import the Microsoft GPG key
        wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

        # Add the VS Code repository to the system
        sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

        # Update the package list again to include the VS Code repository
        sudo apt update

        # Install Visual Studio Code
        sudo apt install code
    ```

- git 
    ```bash
        # install git
        sudo apt install git
    ```

## Get the Repository running

- Define the folder you want the repository to be loaded in and jump into it:  
  I am using a dev folder within Documents
    ```bash
    cd ~/Documents && mkdir dev && cd dev
    ```
- Clone the git-repository we made publicly available
    ```bash
    git clone https://github.com/haas-binge/WILLIBALD-DATA-VAULT-WITH-DBT
    ```
- Start Visual studio code

  Jump into the newly generated directory 

    ```bash
    cd WILLIBALD-DATA-VAULT-WITH-DBT
    # start visual studio from there 
    code .  
    ```

Yes, I trust the authors  😊.  

### Install a virtual python environment
It is good practice to separate different Python projects from each other, not "polluting" the base installation with all the packages, only necessary within a certain project, so we are doing that as well:

Open a bash terminal within Visual Studio Code.

Run the following commands:

```bash
    sudo apt install python3-venv
    python3 -m venv venv
    # to switch to the newly generated virtual environment, run:
    source venv/bin/activate
    # to update pip within the virtual environment:
    python3 -m pip install --upgrade pip setuptools  
```

### Load all necessary packages
To install dbt:
```bash
    pip install -r requirements.txt
```
This will install all programs defined within the document requirements.txt in the root of your project.
We only defined dbt-snowflake==1.6.0, but based on this dbt-core will be installed as well.

```bash
    dbt deps  
```    
This will install all packages defined within the packages.yml in the root of your project.


One of the Packages installed then is https://github.com/haas-binge/dwa-compare-dbt-package.git  
It includes all of the additional macros, we defined in addition to datavault4dbt to make the solution work. 

It is not part of dbt package-management, thats why the following message will appear:
```
    WARNING: The git package "https://github.com/haas-binge/dwa-compare-dbt-package.git" 
            is None.
            This can introduce breaking changes into your project without warning!

    See https://docs.getdbt.com/docs/package-management#section-specifying-package-versions
```
Just ignore this warning.

## Get Snowflake account running and connected
If you don’t already have a snowflake account, now is the time to do this (there is a 30 day free trial available).

### Sign up for a Snowflake account

Go to:
https://signup.snowflake.com/

For further information see: 
https://docs.snowflake.com/user-guide/admin-trial-account

The Snowflake Standard edition is enough and it doesn't matter, which cloud provider you choose and where it is located  
We'd suggest to use the one nearest to you, though.

Within Snowflake you only need to create a data warehouse database.

Let's call the database DWH_WILLIBALD (in this document and its scripts it will be referenced as this).


### Connect dbt with the Snowflake account

Within the profiles.yml all relevant information to connect to the snowflake-account is defined 

Some of the information is hidden in environment variables, others is defined within profiles.yml.

To define the necessary environment variables that are available for a specific user within a linux-installation,  
you can add them to the user's shell configuration file

```
#Open the user's shell configuration file using a text editor. 
nano ~/.bashrc
```
Add your environment variable definition at the end of the file. 

```bash
    export DWH_SNOWFLAKE_ACCOUNT="my_account"  
	# you will find your account in Snowflake under Admin - Accounts -> click copy link it will look something like https://xxxx-yy1234.snowflakecomputing.com
    # only use xxxx-yy1234 as "my_account"!
    export DWH_USER="my_dwh_user" 
    # you will find the user under Admin - Users & Roles   
    export DWH_PASSWORD="my_password"     
    export DWH_DATABASE="my_database" 
    # DWH_WILLIBALD or the name you chose
    export DWH_SOURCE_DATABASE="DWA_COMPARE"  
    # keep that name, if you want to use the privat share we are providing
```


Save the file and exit the text editor.

To apply the changes to the current session, either restart the terminal or run the following command:
```
source ~/.bashrc
```
The environment variable will now be available in all future terminal sessions for that user.

If you ran this on your terminal in vs-code, you will have to activate the python virtual environment again:

```
source venv/bin/activate
```

To check if the dbt-configuration and the connection to the database is properly working run

```
dbt debug
```

All checks should be ok.

## Connect to the source data

Our initial setup contained an AWS S3 datalake (see page 7 in the presentation Willibald_with_dbt_slides.pdf) with external tables in snowflake referencing them. 
To simplify the process we now offer the data (in the way they looked as external tables) as a snowflake private share named DWA_COMPARE. 
If you want to access it, just contact us, we are happy to add you.

See [Willibald data vault with dbt - 00 - introduction](Willibald_data_vault_with_dbt-00-introduction.md) for contact data.

All we need from you is your Snowflake account name.
Within Snowflake/Admin/Accounts click on your account and copy the link, it will look like:
https://xxxx-yy1234.snowflakecomputing.com

As soon as we added you to the private share, the database dwa_compare will show up under Snowflake/Data/Private Sharing.
You will need to click on GET to activate this private share for you (and follow the snowflake instructions via email).

## Run the full solution

Now you can run the following command within your virtual python environment to generate the complete solution.
```
dbt build
```

If you did everything right and we documented everything properly, you now should have the complete solution up and running.

If you encountered any problems, found topics we should add to this description to make it easier for others to set it up, please contact us:  
See [Willibald data vault with dbt - 00 - introduction](Willibald_data_vault_with_dbt-00-introduction.md) for contact data.









