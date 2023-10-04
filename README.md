
DDVUG Challenge 2023 Willibald-Samen (dbt)

This project contains the complete implementation of the DDVUG Data Warehouse Challenge 2023 Willibald-Samen using dbt (data build tool).

Our aim is to make it as easy as possible for you to setup the fully functional solution for yourself.

For further information regarding the DDVUG Challenge see: https://dwa-compare.info/
Link to the Video of the TDWI presentation: https://www.youtube.com/playlist?list=PLFcYych8PxveerZ-J9POQ4WpFcbd1rhvJ
Link to the Powerpoint of the TDWI presentation: [Link Text](useful_documents/Willibald_with_dbt_slides.pdf)

In addition to the package datavault4dbt from Scalefree (https://github.com/ScalefreeCOM/datavault4dbt) we defined our own macros published as the package datavault_extension (see packages.yml).

Our initial setup contained an AWS S3 datalake (see page 7 in the presentation) with external tables in snowflake referencing them. 
To simplify the process we now offer the data (in the way they looked as external tables) as a snowflake private share named DWA_COMPARE. 
If you want to access it, just contact us, we are happy to add you.


Getting Started
- you need to have a snowflake account (30-day free trial available)
- clone the repository and navigate to the project directory.
- install python 3.9
- create venv: python -m venv venv
- upgrade pip: python -m pip install --upgrade pip
- install dbt (with snowflake 1.6.0): pip install -r requirements.txt
- install dependencies: dbt deps
- configure your database connection using the dbt configuration file or edit profiles.yml in source-directory (includes adding three environment-variables).
- how to get the base data
    1. Easiest Option: contact us to get access to the private share DWA_COMPARE
    2. get the data from https://github.com/m2data/Willibald-Data 
        - put the data in your s3-bucket (or azure data lake), configure external tables on snowflake and alter existing definitions (under dwh_01_ext)

                                                           / misc     - kategorie_termintreue - kategorie_termintreue_20220307_20220307_080000.csv ...
        - our s3-bucket looks like ddvug-willibald-samen-dbt--ldts-  roadshow - bestellung - bestellung_20220307_20220307_080000.csv ...
                                                           \ webshop  - bestellung - bestellung_20220314_20220314_080000.csv ...
                                                                      \ kunde      - kunde_20220314_20220314_080000.csv
                                                                                     kunde_20220321_20220321_080000.csv                
                                                                                     kunde_20220328_20220328_080000.csv
                                                                      \ ..
        - adapt the source_type in the load-models. Replace snowflake_external_table_surrogate with snowflake_external_table

- run the dbt commands (dbt build) to create your data models and transform your data.


Please:
- take a look at the naming-conventions ( useful_documents\naming_convention.md )
- note that our macros are only written for snowflake
- note that there are several objects/macros we wrote, that are not supported by datavault4dbt at this time but maybe in the future
- note that the macros we wrote in part depend on the naming-conventions we set up

Install  (newer / other versions not tested)



Contributing
We do not expect contributions to this project. If you have any suggestions please contact us.

License
This work is licensed under a Creative Commons Attribution 4.0 International License: 
http://creativecommons.org/licenses/by/4.0/

Acknowledgements
This project was inspired by the dbt documentation, scalefree and community. We would like to thank the dbt labs team and scalefree.

Disclaimer
THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.