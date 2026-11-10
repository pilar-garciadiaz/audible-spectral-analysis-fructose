# audible-spectral-analysis-fructose
MATLAB implementation of spectral data processing and GGA-ELM classification for aqueous fructose solutions excited with audible sound.

[![Article DOI](https://img.shields.io/badge/Article-10.3390%2Fapp11167301-blue)](https://doi.org/10.3390/app11167301)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a-orange)](#software-requirements)
[![License](https://img.shields.io/badge/Project%20code-Apache--2.0-green)](LICENSE)

## Overview

This repository contains the MATLAB research software associated with:

> García Díaz, P., Utrilla Manso, M., Alpuente Hermosilla, J., and Martínez Rojas, J. A. (2021). Study of the Optimal Waveforms for Non-Destructive Spectral Analysis of Aqueous Solutions by Means of Audible Sound and Optimization Algorithms. *Applied Sciences*, 11(16), 7301. https://doi.org/10.3390/app11167301

The software supports non-destructive spectral analysis and classification of aqueous fructose solutions using audible sound. It contains two MATLAB components:

1. `src/spectrum data acquisition/`, which processes acoustic spectra and prepares the input information required by the classifier.
2. `src/classifier/`, which performs feature extraction and concentration classification using a grouping genetic algorithm and an Extreme Learning Machine fitness function.

The software was publicly released on 10 November 2026 to support inspection, preservation, reuse, and reproducibility under open-science principles.

## Scientific objective

The associated study evaluates audible acoustic spectroscopy as a low-cost, non-contact method for discriminating fructose concentrations in distilled water. The article reports 364 acoustic measurements from 28 concentrations. Each spectrum is represented by 655 values from 20 Hz to 22.05 kHz. A grouping genetic algorithm and an Extreme Learning Machine are used to extract a small set of discriminative frequencies.

## Experimental workflow

1. Generate audible excitation signals, including maximum length sequence signals.
2. Excite the liquid samples inside an anechoic chamber.
3. Record the scattered acoustic response.
4. Divide each 30 s recording into 2 s intervals.
5. Calculate the power spectrum using Praat.
6. Apply cepstral smoothing and spectral decimation to obtain 655 spectral values.
7. Use `src/spectrum data acquisition/` to read, process, average, and present the spectral information in the classifier input format.
8. Use `src/classifier/programa.m` to run the classification workflow.
9. Extract frequency groups with the grouping genetic algorithm.
10. Evaluate candidate groups with an Extreme Learning Machine.
11. Select and evaluate individual and combined classifiers.

Raw audio recording and Praat spectrum generation are not automated by the MATLAB code in this repository.

## Experimental data

| Group | Fructose concentrations | Increment | Samples per concentration | Total samples |
|---|---:|---:|---:|---:|
| Units | 0–9 g/L | 1 g/L | 13 | 130 |
| Tenths | 2.1–2.9 g/L | 0.1 g/L | 13 | 117 |
| Hundredths | 2.01–2.09 g/L | 0.01 g/L | 13 | 117 |
| **Total** | **28 concentrations** |  |  | **364** |


The complete research data are to be deposited in a trusted research-data repository. When the persistent identifier is available, replace the following marker:

```text
Dataset DOI: [DATASET DOI TO BE ADDED]
```

Do not duplicate the complete dataset in GitHub unless its license expressly permits redistribution. A small, non-sensitive validation example may be included.

## Reference algorithm configuration

| Parameter | Published value |
|---|---:|
| Maximum generations | 50 |
| Training data | 80% |
| Testing data | 20% |
| Population size | 50 individuals |
| Mutation probability | 0.1 |
| ELM neurons, unit increments | 10 |
| ELM neurons, tenths and hundredths | 11 |

Five independent simulations were performed for each sample collection. The article reports an approximate runtime of one hour per simulation on a 2.7 GHz Intel Core i7 processor.

## Reference classifiers and results

| Classifier | Selected frequencies in kHz |
|---|---|
| Classifier 1 | 8.4, 11.7, 13.8, 14.7 |
| Classifier 2 | 3.1, 11.2, 12.8, 13.0, 14.5 |

| Concentration set | Combined classifier accuracy | Standard deviation |
|---|---:|---:|
| 0–9 g/L, 1 g/L increments | 99.82% | 0.0123 |
| 2.0–3.0 g/L, 0.1 g/L increments | 98.98% | 0.0266 |
| 2.00–2.10 g/L, 0.01 g/L increments | 98.65% | 0.0272 |

## Repository structure

```text
.
├── README.md
├── CITATION.cff
├── LICENSE
├── THIRD_PARTY_NOTICES.md
├── licenses/
│   ├── mtit-LICENSE.txt
│   └── ELM-LICENSE.txt
└── src/
    ├── classifier/
    │   ├── Datos/
    │   ├── agrupamiento_individuos.m
    │   ├── cruce_individuos.m
    │   ├── cruce_individuos_suma.m
    │   ├── cruzar_parejas.m
    │   ├── ELM.m
    │   ├── evaluacion_individuo.m
    │   ├── generar_poblacion_inicial.m
    │   ├── genetico.m
    │   ├── genetico_winners.m
    │   ├── leer_datos.m
    │   ├── mtit.m
    │   ├── mutacion_individuo.m
    │   ├── mutacion_individuo_adyacentes.m
    │   ├── mutacion_individuo_banda_elim.m
    │   ├── mutacion_individuo_grupo_mas.m
    │   ├── mutacion_individuo_grupo_menos.m
    │   ├── programa.m
    │   └── reparacion_individuo.m
    └── spectrum data acquisition/
        ├── dibujar.m
        ├── dibujar_matriz_datos.m
        ├── leer_datos.m
        ├── leer_datos_unsorted_measures.m
        └── promedio_datos.m
```

`bubbleplot.m` is intentionally not distributed in this repository because its original authorship and redistribution license could not be verified.

## Source-code components

### Spectrum-data processing

| File | Purpose |
|---|---|
| `leer_datos.m` | Reads spectral data |
| `leer_datos_unsorted_measures.m` | Reads spectral measurements that have not been sorted previously |
| `promedio_datos.m` | Averages spectral measurements |
| `dibujar.m` | Plots spectra or processed data |
| `dibujar_matriz_datos.m` | Visualizes the processed data matrix |

These files process the acoustic spectra and prepare the input information required by the classifier.

### Classification

The main classification executable is:

```text
src/classifier/programa.m
```

The remaining files implement data reading, initial population generation, grouping, crossover, mutation, repair, individual evaluation, genetic optimization, visualization, and Extreme Learning Machine evaluation.

## Software requirements

- MATLAB R2020a.
- Base MATLAB only; no additional MATLAB toolboxes are required by the project code.
- Microsoft Windows, using the same validation environment as the previously archived software release https://doi.org/10.5281/zenodo.23987283.
- Praat 6.0.40 was used in the published preprocessing workflow but is not called directly by the released MATLAB code.
- Audacity was used for recording and for generating some excitation signals but is not a runtime dependency of the MATLAB classification workflow.
- `bubbleplot.m` is an optional external visualization dependency and is not distributed with this repository.

## External `bubbleplot.m` requirement

`bubbleplot.m` is excluded because no authoritative original source and redistribution license could be verified. If a workflow path calls `bubbleplot`, the user must provide a lawfully obtained, MATLAB-compatible implementation with this interface:

```matlab
h = bubbleplot(x, y, z, color, sf)
```

Place the external file in a directory outside the repository and add that directory to the MATLAB path before running the affected visualization:

```matlab
addpath('C:\path	o\externalubbleplot');
```

The classification calculations should be kept separate from optional visualization. If `bubbleplot.m` is required only to create a figure, comment out or disable the corresponding plotting call for non-graphical execution. Do not commit an unlicensed copy of `bubbleplot.m` to this repository or to a Zenodo release.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/[GITHUB-USER]/[REPOSITORY-NAME].git
cd [REPOSITORY-NAME]
```

Replace the repository placeholder after the public GitHub URL is known.

### 2. Start MATLAB

Open MATLAB R2020a and set the repository root as the current directory:

```matlab
projectRoot = pwd;
```

Both source directories contain a file named `leer_datos.m`. Do not add the complete `src` tree indiscriminately. Add only the component required for the current stage.

## Running the software

### Stage 1. Process the spectra

```matlab
projectRoot = pwd;
componentPath = fullfile(projectRoot, 'src', 'spectrum data acquisition');
addpath(componentPath);
cd(componentPath);
```

Run the required processing sequence using:

```text
leer_datos.m
leer_datos_unsorted_measures.m
promedio_datos.m
dibujar.m
dibujar_matriz_datos.m
```

These files read and process the spectral measurements, average them where required, and prepare the input information expected by the classifier. Preserve the generated classifier input in the expected `src/classifier/Datos/` structure.

After this stage, remove the component from the MATLAB path:

```matlab
rmpath(componentPath);
```

### Stage 2. Run the classifier

```matlab
classifierPath = fullfile(projectRoot, 'src', 'classifier');
addpath(classifierPath);
cd(classifierPath);
programa
```

`programa.m` is the main executable for classification. Ensure the processed input data are available in `Datos/` and document each random seed, input filename, output filename, and parameter value used for a reproducible run.

### Resolve the `leer_datos.m` name collision

Check the active implementation with:

```matlab
which leer_datos -all
```

Only the implementation belonging to the active stage should be on the MATLAB path.

## Third-party and adapted components

| File | Original source and attribution | Version or revision | License handling |
|---|---|---|---|
| `mtit.m` | `us`, *mtit: a pedestrian major title creator*, MATLAB Central File Exchange 3218 | Version 1.1.0, 13 November 2009 | Preserve the upstream license in `licenses/mtit-LICENSE.txt` and the original file header |
| `ELM.m` | Qin-Yu Zhu and Guang-Bin Huang, Nanyang Technological University; locally adapted by Pilar García Díaz | Original code dated April 2004; located GitHub revision `bfd0555` | Preserve the upstream license in `licenses/ELM-LICENSE.txt`, the original header, and the local modification notice |
| `bubbleplot.m` | Original source and license not verified | Not applicable | Not distributed; optional external visualization dependency |

Sources:

- `mtit.m`: https://www.mathworks.com/matlabcentral/fileexchange/3218-mtit-a-pedestrian-major-title-creator
- `ELM.m`: https://github.com/ExtremeLearningMachines/ELM-Auto-Encoder/blob/master/ELM.m

The main project license does not replace or override the licenses of third-party components.

## Authorship

Pilar García Díaz is the author of the project-specific MATLAB software. `mtit.m` and the original ELM implementation are third-party works. `ELM.m` contains local adaptations by Pilar García Díaz. `bubbleplot.m` is not distributed.

## Testing and reproducibility

A reproducibility report should record:

```text
Software version: 1.0.0
Release date: 2026-11-10
Software DOI: https://doi.org/10.5281/zenodo.24119982
Git commit:
Dataset DOI and version: [DATASET DOI TO BE ADDED]
MATLAB release: R2020a
MATLAB toolboxes: none beyond base MATLAB
Operating system: Microsoft Windows
Random seed:
Maximum generations: 50
Population size: 50
Mutation probability: 0.1
Training/testing split: 80/20
```

Because the optimization procedure is stochastic, exact reproduction requires the same data, preprocessing, code version, parameters, random seeds, and numerical environment.

## Known limitations

- The method was validated for distilled-water and fructose solutions under the experimental conditions described in the article.
- Results depend on the acoustic chamber, container, sound source, microphone, recording chain, preprocessing, and sample preparation.
- The grouping genetic algorithm may identify different high-performing frequency groups between runs.
- Both source directories contain `leer_datos.m`; MATLAB path order must therefore be managed explicitly.
- `bubbleplot.m` is not distributed, so plots that call it require a separately obtained compatible implementation or must be disabled.
- Compatibility with MATLAB releases other than R2020a has not been established.

## Citation

If you use this software, cite the archived software release, the associated article, and the research dataset.

### Software

```text
García Díaz, P. (2026). MATLAB software for non-destructive audible
spectral analysis of aqueous fructose solutions (Version 1.0.0)
[Computer software]. Zenodo. https://doi.org/10.5281/zenodo.24119982
```

### Article

```bibtex
@article{GarciaDiaz2021OptimalWaveforms,
  author  = {García Díaz, Pilar and Utrilla Manso, Manuel and Alpuente Hermosilla, Jesús and Martínez Rojas, Juan A.},
  title   = {Study of the Optimal Waveforms for Non-Destructive Spectral Analysis of Aqueous Solutions by Means of Audible Sound and Optimization Algorithms},
  journal = {Applied Sciences},
  year    = {2021},
  volume  = {11},
  number  = {16},
  pages   = {7301},
  doi     = {10.3390/app11167301},
  url     = {https://doi.org/10.3390/app11167301}
}
```

### Dataset

```text
[DATASET CITATION AND DOI TO BE ADDED]
```

## License

Project-specific software authored by Pilar García Díaz is released under the Apache License 2.0. See `LICENSE`.

Third-party files retain their original copyright and license terms. See `THIRD_PARTY_NOTICES.md` and the corresponding files under `licenses/`.

## Preservation and related outputs

| Output | Persistent identifier |
|---|---|
| Article | https://doi.org/10.3390/app11167301 |
| Dataset | `[DATASET DOI TO BE ADDED]` |
| Software release | https://doi.org/10.5281/zenodo.24119982 |

Stable releases are intended to be archived in Zenodo through the GitHub integration. Use the version DOI for exact reproducibility and the concept DOI to refer to all software versions.
