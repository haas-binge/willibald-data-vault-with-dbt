
# Willibald data vault with dbt

This project contains the complete implementation of the DDVUG Data Warehouse Challenge 2023 Willibald-Samen using dbt (data build tool).

Our aim is to make it as easy as possible for you to set up the fully functional solution for yourself.

## Tutorials and documents describing the solution

We set up the following tutorials/document to guide you through our solution:

[Willibald data vault with dbt - 00 - introduction](useful_documents/Willibald_data_vault_with_dbt-00-introduction.md)   
Short introduction about us and what this is all about.

[Willibald data vault with dbt - 01 - installation guidelines using ubuntu and dbt-core](Willibald_data_vault_with_dbt-01-installation_guidelines_using_ubuntu_and_dbt_core.md)  
A detailed step by step tutorial to set up our solution using an ubuntu virtual machine. If you installed this, you will have the fully functional solution up and running in your own snowflake account. No prior knowledge of dbt necessary.

[Willibald data vault with dbt - 01 - installation guidelines using dbt cloud](Willibald_data_vault_with_dbt-01-installation_guidelines_using_ubuntu_and_dbt_core.md)  
A detailed step by step tutorial to set up our solution using dbt cloud. 
If you installed this, you will have the fully functional solution up and running in your own snowflake account. No prior knowledge of dbt necessary.


[Willibald data vault with dbt - 02 - solution overview](useful_documents/Willibald_data_vault_with_dbt-02-solution_overview.md)  
In this document we will go through our solution, describing some basic features of dbt using our solution and have a look at the different layers we set up and arguing, why we did it that way.

[Willibald data vault with dbt - 03 - the data challenges and how we solved them](useful_documents/Willibald_data_vault_with_dbt-03-the_data_challenges_and_how_we_solved_them.md)  
Description of all the data challenges presented in the data set including a description on how we solved them.

[Willibald data vault with dbt - 04 - overarching functions](useful_documents/Willibald_data_vault_with_dbt-04-overarching_functions.md)  
Description of all the overarching functions we were required to comment on within the challenge.

[Willibald data vault with dbt - 05 - yedi tests and testing in general](useful_documents/Willibald_data_vault_with_dbt-05-yedi_tests_and_testing_in_general.md)  
How we solved the yedi test challenge and some examples of singular and generic tests.

[Willibald data vault with dbt - 06 - closing the gap between business and tech](useful_documents/Willibald_data_vault_with_dbt-06-closing_the_gap_between_business_and_tech.md)  
Description of how we closely integrated this dbt-solution with [dataspot.](https://www.dataspot.at/en/) a data governance tool. That way we are coming close to our vision of an ideal data warehouse setup.



## Getting started quick guide
For those, who are familiar with dbt, here is a short instruction on how to install.  
We'd still recommend looking at our documentation regarding the specifics of our solution.  

Our initial setup contained an AWS S3 datalake with external tables in snowflake referencing them.  
To simplify the process we now offer the data (in the way they looked as external tables) as a snowflake private share named DWA_COMPARE.  
If you want to access it, just contact us, we are happy to add you.  
See [Willibald data vault with dbt - 00 - introduction](useful_documents/Willibald_data_vault_with_dbt-00-introduction.md) for contact data.


- you need to have a snowflake account (30-day free trial available)
- clone the repository and navigate to the project directory.
- install python 3.9
- create venv: python -m venv venv
- upgrade pip: python -m pip install --upgrade pip
- install dbt (with snowflake 1.6.0): pip install -r requirements.txt
- install dependencies: dbt deps
  (In addition to the package datavault4dbt we defined our own macros published as the package datavault_extension (see packages.yml)).
- configure your database connection using the dbt configuration file or edit profiles.yml in source-directory (includes adding three environment-variables).
- how to get the base data
   - contact us to get access to the private share DWA_COMPARE  
- run the dbt commands (dbt build) to create your data models and transform your data.




Please:
- take a look at the [naming conventions](useful_documents\naming_convention.md )
- note that our macros are only written for snowflake
- note that there are several objects/macros we wrote, that are not supported by datavault4dbt at this time but maybe in the future
- note that the macros we wrote in part depend on the naming-conventions we set up

Installation of newer / other versions was not tested


## Contributing
We do not expect contributions to this project. If you have any suggestions please contact us.  
See [Willibald data vault with dbt - 00 - introduction](useful_documents/Willibald_data_vault_with_dbt-00-introduction.md) for contact data.

## License
This work is licensed under a Creative Commons Attribution 4.0 International License: 
http://creativecommons.org/licenses/by/4.0/

## Acknowledgements
This project was inspired by the dbt documentation, scalefree and community. We would like to thank the [dbt labs team](https://www.getdbt.com/) and [Scalefree](https://www.scalefree.com/).

## Disclaimer  
THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.