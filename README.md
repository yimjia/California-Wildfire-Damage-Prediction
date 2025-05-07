# California-Wildfire-Damage-Prediction
We developed a machine learning model to predict the probability of wildfire-induced damage states for structures across California, USA, using the CAL FIRE Damage Inspection (DINS) dataset (https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::cal-fire-damage-inspection-dins-data).

Two wildfire damage states, derived from the CAL FIRE Damage Inspection (DINS) dataset, are considered in this study: **Unaffected to Minor Damage** and **Moderate to Severe Damage**. They are separated using a threshold of 10%, based on the percentage of structural damage observed during post-fire assessments. 


For more information, please refer to the following:\
Jia, Y., and Opabola, E. (2025). "Interpretable Machine Learning Insights into Wildfire Damage Drivers in California, USA", *International Journal of Disaster Risk Reduction*, xxx: xxxxx (https://xxxxxxx).
<br/><br/>

As **prerequisites**, users need to have access to run Python and MATLAB codes. No training in machine learning is required to perform the wildfire damage state prediction for California. 

To **download** the codes, please navigate to the main page of this repository, click the green **Code** button, and in the menu that appears, click **Download ZIP**. 

The **Model** folder includes the *codes* to perform the wildfire damage state prediction for structure in California, USA, and a *step-by-step instruction*. 


Note that the codes were run on Python 3.12.7 (TensorFlow 2.18.0 required) and MATLAB R2023b. The authors recommend running the Python codes on Jupyter Notebook. Running the codes on different versions of Python, TensorFlow, or MATLAB may result in compatibility issues. However, most compatibility issues can be resolved by following the suggestions in the error messages.
