# TCP_IP-Strain-Telemetry-Data
This repository allows wireless data sending of strain measurements from the IBSEN® I-MON 256 USB to a PC running MATLAB®. The server program is coded in LabView® as add-ons of the original interrogator's software while the client program is coded in MATLAB® to receive and storage the stain data.

This is the code which allows wireless stain transmission of the following research study. The code was tested to send information from a UAV to groud using a point-to-point interal wireless connection.

Alvarez-Montoya, J., Carvajal-Castrillón, A., & Sierra-Pérez, J. (2020). In-flight and wireless damage detection in a UAV composite wing using fiber optic sensors and strain field pattern recognition. Mechanical Systems and Signal Processing, 136, 106526. https://doi.org/10.1016/j.ymssp.2019.106526

More information about the code and its development can be found at Alvarez-Montoya, J. & Carvajal-Castrillón, A. (2018). DEVELOPMENT OF A REMOTE ACQUISITION SYSTEM OF STRAIN
MEASUREMENTS IN AN UNMANNED AERIAL VEHICLE TO INFER ITSSTRUCTURAL INTEGRITY. Universidad Pontificia Bolivariana, Colombia.

The software involved in the data transmission system is divided into two parts: the software running at the on-board computer (client), and the one running at the ground station computer (server).

The TCP/IP alternative was selected to be used at the flight tests, as it is the simplest and most straightforward procedure tested. This is the combination of both the TCP and
IP protocols. The former guarantees the correct transmission of data through a network, it ensures that information packages are correct and is in charge of asking for a package again if there is something wrong with it during the transmission. The latter indicates how the packages are transmitted and where do they have to arrive.

## Client

The code was implemented in MATLAB® with simple writing and reading functions applied to TCP/IP objects. The scrip saves the information to disk each hundred data
lines, with the purpose of releasing the information and making it available for loading at a processing program.

## Server

The interrogator's software was modified with TCP/IP functions to work as a data server.



