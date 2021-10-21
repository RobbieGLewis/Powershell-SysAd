# SysAd


<div id="top"></div>




<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">SysAd.ps1</h3>

  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project


![SysAD terminal interface](https://i.imgur.com/ZuJO7po.png)

SysAd.ps1 is a collection of PowerShell functions served under a terminal interface aimed at System Administrators or Support Engineers to quickly connect via terminal, either Pa/Psexec.exe (CMD) or Powershell, to assist in remote fixes or automating common tasks.

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Powershell 7](https://github.com/PowerShell/PowerShell)
* [Windows Terminal](https://github.com/microsoft/terminal)


<p align="right">(<a href="#top">back to top</a>)</p>


### Prerequisites


* [RSAT for Active Directory tools](https://docs.microsoft.com/en-us/windows-server/remote/remote-server-administration-tools)

* [Windows Terminal](https://github.com/microsoft/terminal)

Although Windows Terminal is not a prerequiste, I highly recommend it for frequent terminal use (like this repo is targeted at), to install open Powershell and run:

  ```sh
    Add-AppxPackage Microsoft.WindowsTerminal_<versionNumber>.msixbundle
  ```

For alternative installation methods, see the link above to the Windows Terminal repo.

## Installation

If you have GIT installed on your Windows machine, simply open Powershell at your target location:

  ```sh
  git clone https://github.com/jameswylde/SysAd.git
  ```

If you do not have GIT, open 'Code' at the top of this repo, 'Download ZIP', download and extract at your target location.


<!-- USAGE EXAMPLES -->
## Usage

Simple open Powershell or Windows Terminal as admin, cd into the SysAd folder and run:


```sh
  ./SysAd.ps1
  ```

<!-- Features-->
## Features

The script is built around the task of quickly getting onto machines via. the command line which is done here using PaExec.exe, PsExec.exe and PSRemoting. As these sessions are silent, they're especially useful for non-intrusive works.

It's also built around speed in mind, with the press of a button you can get a full list of logged on users, full software inventory, shutdown logs (invoked from where, with what, by who), largest file sizes - all within a second of pressing the designated key at the TUI menu.

It also has misc functions included for bespoke tasks or tiresome GUI tasks, such as quickly searching your DHCP server for a hostname, lease, IP, scope or updating McAffee EPO and running a SNOW inventory. The terminal interface's simplicity means adapting the script for your bespoke functions is as simple as defining a function, adding its name to *function Show-Home* and then corresponding keypress to *Show-Home*. In recent times, I've added two functions - one to help alleviate Print-Nightmare issues with UAC prompts, it will connect to the target machine remove the printer driver UAC for 2 minutes, so printer drivers can be reinstalled without manual intervention, and then reverts. In the same group, is a SCCM/MECM Remote Control tool, which will connect to the machine and bypass the 'user approval' when remoting onto a machine with Remote Control - again reverting after 2 minutes.

It also features a small Active Directory suite which brances off into it's own TUI, with some common tasks. Find all locked out users in an OU, search users and display key info (with option to unlock and reset passwords here) as well as some automation of AD group management and some reporting tools.


```sh
  ./SysAd.ps1
  ```

Script landing page to enter your target's hostname or IP address:


![SysAD landing](https://i.imgur.com/cGgmBwg.png)


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

James W - [@jamescw44](https://twitter.com/jamescw44)

Project [https://github.com/jameswylde/SysAd](https://github.com/jameswylde/SysAd)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/jameswylde/SysAd.svg?style=for-the-badge
[contributors-url]: https://github.com/jameswylde/SysAd/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/jameswylde/SysAd.svg?style=for-the-badge
[forks-url]: https://github.com/jameswylde/SysAd/network/members
[stars-shield]: https://img.shields.io/github/stars/jameswylde/SysAd.svg?style=for-the-badge
[stars-url]: https://github.com/jameswylde/SysAd/stargazers
[issues-shield]: https://img.shields.io/github/issues/jameswylde/SysAd.svg?style=for-the-badge
[issues-url]: https://github.com/jameswylde/SysAd/issues
[license-shield]: https://img.shields.io/github/license/jameswylde/SysAd.svg?style=for-the-badge
[license-url]: https://github.com/jameswylde/SysAd/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png
