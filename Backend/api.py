from flask import Flask,request,jsonify
import subprocess
from transformers import AutoModelForSequenceClassification
from transformers import TFAutoModelForSequenceClassification
from transformers import AutoTokenizer, AutoConfig
import numpy as np
from scipy.special import softmax



app = Flask(__name__)


@app.route("/", methods=['GET'])
def home():
    fquery=str(request.args['query'])
    # print(fquery)
    Tweet = fquery.split("/")[-1]
    Tweet = Tweet[:-1]
    print(Tweet)
    MODEL = f"cardiffnlp/twitter-roberta-base-sentiment-latest"
    tokenizer = AutoTokenizer.from_pretrained(MODEL)
    config = AutoConfig.from_pretrained(MODEL)
    model = AutoModelForSequenceClassification.from_pretrained(MODEL)
    # text = "This is not terrible. I'm not very disappointed"
    # encoded_input = tokenizer(text, return_tensors='pt')
    encoded_input = tokenizer(Tweet, return_tensors='pt')
    output = model(**encoded_input)
    scores = output[0][0].detach().numpy()
    scores = softmax(scores)
    print(scores)
    ranking = np.argsort(scores)
    ranking = ranking[::-1]
    st = ""
    c =config.id2label[ranking[0]]
    for i in range(scores.shape[0]):
        l = config.id2label[ranking[i]]
        s = scores[ranking[i]]
        st = st + f"{i+1}. {l} {np.round(float(s), 4)}\n"
        # print(f"{i+1}) {l} {np.round(float(s), 4)}")
    print(st)
    print(c)
    dic={}
    dic['output'] = st
    dic['color'] = c
    return jsonify(dic) 
if __name__ == "__main__":
    app.run()