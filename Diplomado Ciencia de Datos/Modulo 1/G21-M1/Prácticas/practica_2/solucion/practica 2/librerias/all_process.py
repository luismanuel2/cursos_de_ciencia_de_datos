import os
import sys
from os.path import dirname
sys.path.append(dirname(__file__))
from pathlib import Path
path = Path(__file__).parent.absolute()
from process import *




class first_part(BaseEstimator,TransformerMixin):
    def __init__(self):
        self.reviews=reviews()
        self.calendar=calendar()
        self.rename=rename_columns()
        self.feature_engineering=feature_engineering()
        return None
        
    def fit(self,X,y=None):
        y=X[1:]
        X=X[0]
        self.X=X
        self.calendar.fit(y[1])
        self.reviews.fit(y[0])
        self.rename.fit(X)
        

    def transform(self,X,y=None):
        self.y=X[1:]
        X=X[0]
        data_calendar=self.y[1]
        data_reviews=self.y[0]
        data_calendar=self.calendar.transform(data_calendar)
 
        
        data_reviews=self.reviews.transform(data_reviews)
     

        data=self.rename.transform(X,[data_reviews,data_calendar])
        self.feature_engineering.fit(data)
        data=self.feature_engineering.transform(data)
        display(data)

        return data


    def fit_transform(self,X,y=None):
        self.fit(X)
        return self.transform(X)


class second_part(BaseEstimator,TransformerMixin):
    def __init__(self):
     
        self.Imputer=Imputer_Transformations()
        self.cluster=Clustering()
        return None
        
    def fit(self,X,y=None):
        return self
    

    def transform(self,X,y=None):
        data=self.Imputer.transform(X)
        data=self.cluster.transform(data)
        return data

    def fit_transform(self,X,y=None):
        self.fit(X)
        return self.transform(X)