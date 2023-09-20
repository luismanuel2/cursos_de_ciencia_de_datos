import sys
import os
import numpy as np
import pandas as pd
import itertools
from textblob import TextBlob
from sklearn.base import BaseEstimator, TransformerMixin

from collections import Counter
from os.path import dirname
sys.path.append(dirname(__file__))
from pathlib import Path
path = Path(__file__).parent.absolute()


class reviews2( BaseEstimator, TransformerMixin ):
    def __init__(self):
        return None
    def fit(self,id_review,id_airbnb,date,comment,id_reviewer):
        self.id_review=id_review
        self.id_airbnb=id_airbnb
        self.date=date
        self.comment=comment
        self.id_reviewer=id_reviewer
        return self
    
    def transform(self, data):
        data=self.func_reviews(data,self.id_review,self.id_airbnb,self.date,self.comment,self.id_reviewer)
        return data


    def comments(self,polarity,comment):    
        good=[comment[x] for x in [i for i, e in enumerate(polarity) if e == 1]]
        bad=[comment[x] for x in [i for i, e in enumerate(polarity) if e == -1]]
        none=[comment[x] for x in [i for i, e in enumerate(polarity) if e == 0]]
        return [good,bad,none]

    def sentiment(self,text):
        polarity=TextBlob(text).sentiment.polarity
        if polarity <0:
            return -1
        elif polarity>.2:
            return 1
        else:
            return 0

    def func_reviews(self,df_reviews,id_review,id_airbnb,date,comment,id_reviewer):
        
        df_reviews=df_reviews.drop_duplicates(subset=[id_review])
        df_reviews=df_reviews.drop(columns=[id_review])
        df_reviews=df_reviews.rename(columns={id_airbnb:"id"})
        df_reviews[date]=pd.to_datetime(df_reviews[date],yearfirst=True)
        df_reviews["month"]=df_reviews[date].map(lambda x:x.month_name())
        df_reviews=df_reviews.groupby(["id","month"]).agg({id_reviewer:lambda x:list(set(x)),comment:list}).reset_index()
        df_reviews["users_per_month_reviews"]=df_reviews[id_reviewer].map(len)
        df_reviews["comments_per_month_reviews"]=df_reviews[comment].map(len)
        df_reviews=df_reviews.groupby(["id"]).agg({comment:list,"users_per_month_reviews":"mean","comments_per_month_reviews":"mean"}).reset_index()
        df_reviews[comment]=df_reviews[comment].map(lambda x:list(itertools.chain(*x)))
        df_reviews["total_comments"]=df_reviews[comment].map(len)
        df_reviews["polarity_review"]=df_reviews[comment].map(lambda x:[self.sentiment(str(y)) for y in x])
        df_reviews["#_negativos_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==-1,x))))
        df_reviews["#_positivos_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==1,x))))
        df_reviews["#_neutros_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==0,x))))
        df_reviews["comments_polarity"]=df_reviews[[comment,"polarity_review"]].apply(lambda x:self.comments(x[1],x[0]),axis=1)
        df_reviews.rename(columns={"comments":"comments_review"},inplace=True)
        return df_reviews




class calendar(BaseEstimator,TransformerMixin):
    def __init__(self):
        return None
    def fit(self,X,y=None):

        self.id_airbnb="listing_id"
        self.date="date"
        self.price="price"
    def transform(self,X,y=None):
        data=self.func_calendar(X,self.id_airbnb,self.date,self.price)
        return data



    def func_calendar(self,df_calendar,id_airbnb,date,price):
        df_calendar=df_calendar.rename(columns={id_airbnb:"id"})
        df_calendar[date]=pd.to_datetime(df_calendar[date],yearfirst=True)
        df_calendar=df_calendar.sort_values(by=["id",date])
        df_calendar.reset_index(drop=True,inplace=True)
        df_calendar["month"]=df_calendar[date].map(lambda x:x.month)
        df_calendar["year"]=df_calendar[date].map(lambda x:x.year)
        df_calendar[price]=df_calendar[price].map(lambda x:float(str(x).replace("$","").replace(",","")))
        aux_calendar=df_calendar.groupby(["id","year","month"]).agg({price:"mean"}).reset_index()
        aux_calendar=aux_calendar.groupby(["id"]).agg({price:lambda x:pd.DataFrame(x).pct_change().mean()}).reset_index()
        aux_calendar.columns=["id","price_calendar_pct"]
        df_calendar=df_calendar.groupby(["id"]).agg({price:["min","max"]}).reset_index()
        df_calendar.columns=["id","price_calendar_min","price_calendar_max"]
        return df_calendar


class reviews( BaseEstimator, TransformerMixin ):
    def __init__(self):
        return None
    def fit(self,X,y=None):
        self.id_review= "id"
        self.id_airbnb="listing_id"
        self.date="date"
        self.comment="comments"
        self.id_reviewer="reviewer_id"
        return self
    
    def transform(self, X,y=None):
        data=self.func_reviews(X,self.id_review,self.id_airbnb,self.date,self.comment,self.id_reviewer)
      
        return data


    def comments(self,polarity,comment):    
        good=[comment[x] for x in [i for i, e in enumerate(polarity) if e == 1]]
        bad=[comment[x] for x in [i for i, e in enumerate(polarity) if e == -1]]
        none=[comment[x] for x in [i for i, e in enumerate(polarity) if e == 0]]
        return [good,bad,none]

    def sentiment(self,text):
        polarity=TextBlob(text).sentiment.polarity
        if polarity <0:
            return -1
        elif polarity>.2:
            return 1
        else:
            return 0

    def func_reviews(self,df_reviews,id_review,id_airbnb,date,comment,id_reviewer):
        
        df_reviews=df_reviews.drop_duplicates(subset=[id_review])
        df_reviews=df_reviews.drop(columns=[id_review])
        df_reviews=df_reviews.rename(columns={id_airbnb:"id"})
        df_reviews[date]=pd.to_datetime(df_reviews[date],yearfirst=True)
        df_reviews["month"]=df_reviews[date].map(lambda x:x.month_name())
        df_reviews=df_reviews.groupby(["id","month"]).agg({id_reviewer:lambda x:list(set(x)),comment:list}).reset_index()
        df_reviews["users_per_month_reviews"]=df_reviews[id_reviewer].map(len)
        df_reviews["comments_per_month_reviews"]=df_reviews[comment].map(len)
        df_reviews=df_reviews.groupby(["id"]).agg({comment:list,"users_per_month_reviews":"mean","comments_per_month_reviews":"mean"}).reset_index()
        df_reviews[comment]=df_reviews[comment].map(lambda x:list(itertools.chain(*x)))
        df_reviews["total_comments"]=df_reviews[comment].map(len)
        df_reviews["polarity_review"]=df_reviews[comment].map(lambda x:[self.sentiment(str(y)) for y in x])
        df_reviews["#_negativos_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==-1,x))))
        df_reviews["#_positivos_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==1,x))))
        df_reviews["#_neutros_review"]=df_reviews["polarity_review"].map(lambda x:len(list(filter(lambda y:y==0,x))))
        df_reviews["comments_polarity"]=df_reviews[[comment,"polarity_review"]].apply(lambda x:self.comments(x[1],x[0]),axis=1)
        df_reviews.rename(columns={"comments":"comments_review"},inplace=True)
        return df_reviews



class rename_columns(BaseEstimator,TransformerMixin):
    def __init__(self):
        return None
    def fit(self,X,y=None):
        self.columns=["id","host_is_superhost","host_total_listings_count","latitude","longitude","host_verifications","property_type","room_type","accommodates","bedrooms","beds","amenities","price","minimum_nights","maximum_nights","review_scores_rating",'review_scores_cleanliness', 'review_scores_checkin',
       'review_scores_communication', 'review_scores_location',
       'review_scores_value',"comments_review",'users_per_month_reviews',
       'comments_per_month_reviews', 'total_comments', '#_negativos_review',
       '#_positivos_review', '#_neutros_review', 'price_calendar_min',
       'price_calendar_max',"neighbourhood_cleansed","host_id","comments_polarity"]
    def transform(self,X,y=None):
        self.dictio={'categoricas': {'host_is_superhost': 'v_host_is_superhost',
            'host_verifications': 'v_host_verifications',
            'property_type': 'v_property_type',
            'room_type': 'v_room_type',
            'amenities': 'v_amenities',
            'neighbourhood_cleansed': 'v_neighbourhood_cleansed',
            'host_response_time': 'v_host_response_time'},
            'continuas': {'host_total_listings_count': 'c_host_total_listings_count',
            'latitude': 'c_latitude',
            'longitude': 'c_longitude',
            'accommodates': 'c_accommodates',
            'bedrooms': 'c_bedrooms',
            'beds': 'c_beds',
            'price': 'c_price',
            'minimum_nights': 'c_minimum_nights',
            'maximum_nights': 'c_maximum_nights',
            'review_scores_rating': 'c_review_scores_rating',
            'review_scores_cleanliness': 'c_review_scores_cleanliness',
            'review_scores_checkin': 'c_review_scores_checkin',
            'review_scores_communication': 'c_review_scores_communication',
            'review_scores_location': 'c_review_scores_location',
            'review_scores_value': 'c_review_scores_value',
            'comments_review': 'text_comments_review',
            'users_per_month_reviews': 'c_users_per_month_reviews',
            'comments_per_month_reviews': 'c_comments_per_month_reviews',
            'total_comments': 'c_total_comments',
            '#_negativos_review': 'c_#_negativos_review',
            '#_positivos_review': 'c_#_positivos_review',
            '#_neutros_review': 'c_#_neutros_review',
            'price_calendar_min': 'c_price_calendar_min',
            'price_calendar_max': 'c_price_calendar_max',
            'price_calendar_pct': 'c_price_calendar_pct',
            'host_response_rate': 'c_host_response_rate',
            'host_acceptance_rate': 'c_host_acceptance_rate'},
            'texto': {'comments_review': 'text_comments_review',
            'comments_polarity': 'text_comments_polarity'}}

   
        data=X.copy()
        data=data.merge(y[0],on=["id"]).merge(y[1],on=["id"])
        data=data[self.columns]
        data=data.rename(columns=self.dictio["categoricas"])
        data=data.rename(columns=self.dictio["continuas"])
        data=data.rename(columns=self.dictio["texto"])
        return data
    


class feature_engineering(BaseEstimator,TransformerMixin):
    def __init__(self):
        return None
    def fit(self,X,y=None):
        self.col_amenidades="v_amenities"
        self.col_verifications=  "v_host_verifications"
        self.v_host_verifications=['phone','email','government_id','reviews','offline_government_id','jumio','selfie','identity_manual','kba','facebook','work_email','google']
        self.list_amenidades=["Dishes and silverware",'Wifi','Long term stays allowed','Kitchen', 'Smoke alarm','Heating','Essentials','Air conditioning','Carbon monoxide alarm','Hangers','Hair dryer','Iron','Hot water','Dedicated workspace','Shampoo','TV']
    def transform(self,X,y=None):
        data=self.verifications(X,self.col_verifications,self.v_host_verifications)


        data=self.verifications(data,self.col_amenidades,self.list_amenidades)
        return data

    def verifications(self,df,col_verifications,v_host_verifications):
        
        
        df["aux"]=df[col_verifications].map(lambda x:dict(Counter(eval(x)).most_common(10)))
        df_verifi=df["aux"].apply(pd.Series)
        df_verifi=df_verifi.fillna(0)
        #df_verifi=df[[df_verifi=df_verifi.drop(columns=cols)]].copy()

        for i in v_host_verifications:
            #print(i)
            df_verifi[f"{i}"]=df[col_verifications].map(lambda x:1 if i in eval(x) else 0)


        cols=[x for x in df_verifi if x not in v_host_verifications]
        df_verifi["otro"]=df_verifi[cols].apply(lambda x:sum(x),axis=1)



        df_verifi=df_verifi.drop(columns=cols)
        #df_verifi=df_verifi.drop(columns=[col_verifications])
        df_verifi.columns=[col_verifications+"_"+x for x in df_verifi]
        df=pd.concat([df,df_verifi],axis=1)
        df[col_verifications+"_otro"]=df[col_verifications+"_otro"].map(lambda x:1 if x>1 else 0)
       # print(col_verifications.replace("v_","c_"))
        df[col_verifications.replace("v_","c_")]=df[col_verifications].map(lambda x:len(list(set(eval(x)))) if str(eval(x))!="None" else 0)
       # display(df[[col_verifications.replace("v_","c_")]])
        df.drop(columns=["aux"],inplace=True)
        return df


class Imputer_Transformations(BaseEstimator,TransformerMixin):
    def __init__(self):
        dir_path=os.path.join(path,"../clases/imputer.pkl")
        self.imputer=pd.read_pickle(dir_path)
        self.columns=["c_bedrooms","c_beds","c_review_scores_value","c_host_total_listings_count"]
        dir_path=os.path.join(path,"../clases/onehotencoder.pkl")
        self.encoder=pd.read_pickle(dir_path)
        return None

    def fit(self,X,y=None):
        print("imputer")
        return self

    def transform(self,X,y=None):
        data=X.copy()
        data["c_price"]=data["c_price"].map(lambda x:float(str(x).replace("$","").replace(",","")))
        for i in data.filter(like="c_"):
            data[i]=data[i].astype(float)
       
        df=pd.DataFrame(self.imputer.transform(data[self.columns]),columns=self.columns)
        data=data.drop(columns=self.columns)

        df=pd.concat([data,df],axis=1)

        df.loc[df[df["c_price_calendar_min"].isnull()].index,"c_price_calendar_min"]=df.loc[df[df["c_price_calendar_min"].isnull()].index,"c_price"]
        df.loc[df[df["c_price_calendar_max"].isnull()].index,"c_price_calendar_max"]=df.loc[df[df["c_price_calendar_max"].isnull()].index,"c_price"]
        for i in ["c_review_scores_cleanliness","c_review_scores_communication","c_review_scores_checkin","c_review_scores_location"]:
            df.loc[df[df[i].isnull()].index,i]=df.loc[df[df[i].isnull()].index,"c_review_scores_value"]
        df=df.drop(columns=["c_price_calendar_min","c_total_comments","c_users_per_month_reviews"])
        df["v_host_is_superhost"]=df["v_host_is_superhost"].fillna("f")
        df["v_host_is_superhost"]=df["v_host_is_superhost"].replace({"f":0,"t":1})
        room_type=pd.DataFrame(self.encoder.transform(df[["v_room_type"]]).toarray(),columns=['v_room_type_Hotel room','v_room_type_Private room', 'v_room_type_Shared room'])
        df=pd.concat([df,room_type],axis=1)
        return df




class Clustering(BaseEstimator,TransformerMixin):
    def __init__(self):
        #SCALER
        dir_path=os.path.join(path,"../clases/standard_scaler.pkl")
        self.scaler=pd.read_pickle(dir_path)
        #PCA
        dir_path=os.path.join(path,"../clases/pca_sc.pkl")
        self.pca=pd.read_pickle(dir_path)
        #KMEANS
        dir_path=os.path.join(path,"../clases/kmeans_cl_km_pca_sc.pkl")
        self.cluster=pd.read_pickle(dir_path)
        #CONTINUAS
        dir_path=os.path.join(path,"../clases/vars_continuas.pkl")
        self.continuas=pd.read_pickle(dir_path)
        #DISCRETAS
        dir_path=os.path.join(path,"../clases/vars_categoricas.pkl")
        self.categoricas=pd.read_pickle(dir_path)

        return None

    def fit(self,X,y=None):
        print("cluster")
        return self

    def transform(self,X,y=None):
        #display(X)
        id_=X[["id"]]
        data=pd.DataFrame(self.scaler.transform(X[self.continuas]))
        data=pd.DataFrame(self.pca.transform(data),columns=[f"componente_{x}" for x in range(11)])
        data=data.merge(X[self.categoricas],left_index=True,right_index=True)
        data["cl"]=self.cluster.predict(data)
      

        return pd.concat([id_,data],axis=1)[["id","cl"]]

    