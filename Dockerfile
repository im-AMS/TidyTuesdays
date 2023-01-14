FROM rocker/geospatial:4.2.2

RUN R --slave -e "install.packages('tidyverse')"
RUN R --slave -e "install.packages('colorspace')"
RUN R --slave -e "install.packages('corrr')"
RUN R --slave -e "install.packages('cowplot')"
RUN R --slave -e "install.packages('ggdark')"
RUN R --slave -e "install.packages('ggforce')"
RUN R --slave -e "install.packages('ggrepel')"
RUN R --slave -e "install.packages('ggridges')"
RUN R --slave -e "install.packages('ggsci')"
RUN R --slave -e "install.packages('ggtext')"
RUN R --slave -e "install.packages('ggthemes')"
RUN R --slave -e "install.packages('grid')"
RUN R --slave -e "install.packages('gridExtra')"
RUN R --slave -e "install.packages('patchwork')"
RUN R --slave -e "install.packages('rcartocolor')"
RUN R --slave -e "install.packages('scico')"
RUN R --slave -e "install.packages('showtext')"
RUN R --slave -e "install.packages('shiny')"
RUN R --slave -e "install.packages('plotly')"
RUN R --slave -e "install.packages('highcharter')"
RUN R --slave -e "install.packages('echarts4r')"
RUN R --slave -e "install.packages('rnaturalearth')"
RUN R --slave -e "install.packages('rnaturalearthdata')"
RUN R --slave -e "install.packages('gggibbous')"
RUN R --slave -e "install.packages('ggimage')"
RUN R --slave -e "install.packages('ragg')"
RUN R --slave -e "install.packages('maps')"
RUN R --slave -e "install.packages('tidytuesdayR')"
RUN R --slave -e "install.packages('esquisse')"
RUN R --slave -e "install.packages('geomtextpath')"
RUN R --slave -e "install.packages('janitor')"
RUN R --slave -e "install.packages('git2r')"
RUN R --slave -e "install.packages('devtools')"


RUN R --slave -e 'devtools::install_github(c("ropensci/rnaturalearthhires"))'
RUN R --slave -e 'devtools::install_github("yutannihilation/ggsflabel")'
RUN R --slave -e 'devtools::install_github("seasmith/AlignAssign")'
RUN R --slave -e 'devtools::install_github("tidyverse/reprex")'

RUN R --slave -e 'install.packages("rcartocolor")'
RUN R --slave -e 'install.packages("datapasta")'

# create an R user
ENV USER rstudio
# set password
ENV PASSWORD password

# Set working directory
# WORKDIR /home/rstudio/TidyTuesdays


