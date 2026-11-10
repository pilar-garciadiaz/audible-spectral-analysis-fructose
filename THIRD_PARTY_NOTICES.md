# Third-Party Notices

This document identifies third-party components used by the MATLAB research software **MATLAB software for non-destructive audible spectral analysis of aqueous fructose solutions**, version 1.0.0.

The project-specific source code authored by Pilar García Díaz is licensed under the Apache License 2.0. The project license does not replace, modify, or override the copyright and license terms of the third-party components listed below.

## 1. `mtit.m`

- **Component title:** *mtit: a pedestrian major title creator*
- **File in this repository:** `src/classifier/mtit.m`
- **Author shown by the upstream record:** `us`
- **Upstream version:** 1.1.0
- **Release date:** 13 November 2009
- **Original source:** https://www.mathworks.com/matlabcentral/fileexchange/3218-mtit-a-pedestrian-major-title-creator
- **License:** the license supplied with the MATLAB Central File Exchange submission
- **Local license copy:** `licenses/mtit-LICENSE.txt`
- **Local modifications:** none declared; verify this against the upstream version before release

The original source header and all copyright, attribution, and license notices must be preserved. The upstream `license.txt` must be downloaded from the MATLAB Central File Exchange record and stored without modification as `licenses/mtit-LICENSE.txt`.

## 2. `ELM.m`

- **Component:** Extreme Learning Machine implementation
- **File in this repository:** `src/classifier/ELM.m`
- **Original authors:** Qin-Yu Zhu and Guang-Bin Huang
- **Original institution:** Nanyang Technological University, Singapore
- **Original code date:** April 2004
- **Upstream repository:** https://github.com/ExtremeLearningMachines/ELM-Auto-Encoder
- **Upstream source file:** https://github.com/ExtremeLearningMachines/ELM-Auto-Encoder/blob/master/ELM.m
- **Located upstream revision:** `bfd0555`
- **Upstream license:** the `LICENSE` file distributed with the upstream repository
- **Upstream license URL:** https://github.com/ExtremeLearningMachines/ELM-Auto-Encoder/blob/master/LICENSE
- **Local license copy:** `licenses/ELM-LICENSE.txt`
- **Local modifications:** Pilar García Díaz

The local version is a modified derivative of the original ELM implementation. The original attribution and source header must be preserved. The local modifications include direct use of training and testing arrays, data normalization, modified function outputs, and generation of predicted class-label indices.

The upstream `LICENSE` file must be downloaded and stored without modification as `licenses/ELM-LICENSE.txt`. Any notices required by that license must remain with redistributed source and derivative versions.

## 3. `bubbleplot.m`

`bubbleplot.m` is **not distributed** in this repository or in its archived releases because an authoritative original source, authorship statement, and redistribution license could not be verified.

The file is used only for optional generation of figures that visualize results. Its absence does not prevent execution of the classification algorithm.

Some visualization paths may require a separately and lawfully obtained MATLAB-compatible implementation with the following interface:

```matlab
h = bubbleplot(x, y, z, color, sf)
```

Users are responsible for obtaining any compatible implementation under valid license terms and for adding its directory to the MATLAB path. No `bubbleplot.m` file may be added to this repository or to a Zenodo release unless its provenance and redistribution license have been verified.

## Preservation of notices

When redistributing this research software:

1. Retain this `THIRD_PARTY_NOTICES.md` file.
2. Retain the original headers in `mtit.m` and `ELM.m`.
3. Retain `licenses/mtit-LICENSE.txt` and `licenses/ELM-LICENSE.txt` without modification.
4. Clearly identify local changes made to `ELM.m`.
5. Do not represent third-party components as authored by Pilar García Díaz.
6. Do not add `bubbleplot.m` unless its provenance and redistribution license have been verified.

## Disclaimer

The third-party components are provided under their respective upstream terms. References to upstream sources are included for attribution and license traceability. This notice does not grant rights beyond those provided by the corresponding upstream licenses.
