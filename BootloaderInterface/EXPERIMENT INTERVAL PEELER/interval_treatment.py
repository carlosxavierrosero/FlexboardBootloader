__author__ = 'root'
import numpy as np
import matplotlib.pyplot as plt
datos=np.loadtxt("experiment_manel.csp")
tiempo=datos[0:2407].copy()
pendulo=datos[2407:4814].copy()-270
carro=datos[4814:].copy()

pendulo = pendulo*(np.pi/180.0)#to change to radians
carro = carro/100.0 #to change to meters

df=np.diff(pendulo)/0.05
pendulo_dot= (df[0:-1]+df[1:])/2#+np.diff(pendulo)/0.05
df=np.diff(pendulo_dot)/0.05
pendulo_dot_dot=(df[0:-1]+df[1:])/2

df=np.diff(carro)/0.05
carro_dot=(df[0:-1]+df[1:])/2
df=np.diff(carro_dot)/0.05
carro_dot_dot=(df[0:-1]+df[1:])/2

plt.plot(pendulo)
plt.plot(carro)


plt.show()
#plt.show()
movimiento=np.abs(carro_dot[0:60])>0.02
#carro_dot_dot_mov=carro_dot_dot[movimiento].copy()
#carro_dot_dot_mov=carro_dot_dot[movimiento].copy()
plt.plot(carro_dot[movimiento],'x')
plt.show()
file=open("problema.csp","w")
file.write("""Input variables
M in [0,0.5]
m in [0,0.5]
l in [0,0.60]
b in [0,1]
Output variables
Constraints
""")
for i,element in enumerate(carro_dot[movimiento]):
    print (carro_dot_dot[i]*np.cos(pendulo[i])+9.8*np.sin(pendulo[i]))/pendulo_dot_dot[i]
    file.writelines("%f*(M+m)+b*(%f)+m*l*(%f)=0\n"%(carro_dot_dot[i],carro_dot[i],pendulo_dot_dot[i]*np.cos(pendulo[i])-pendulo_dot[i]**2*np.sin(pendulo[i])))
    #file.writelines( "%f*l+(%f)=%f\n"%(pendulo_dot_dot[i],-9.8*np.sin(pendulo[i]),carro_dot_dot[i]*np.cos(pendulo[i])))
file.write("End")
file.close()
#print carro_dot[movimiento]
#print pendulo_dot
