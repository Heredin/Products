import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    setState(() {
      productosBloc.cargarProductos();
    });
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'producto').then((value) {
              setState(() {});
            }));
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
        stream: productosBloc.productosStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemBuilder: (context, i) =>
                    _crearItem(context, productosBloc, productos[i]),
                itemCount: productos.length);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    // return FutureBuilder(
    //     future: productos.cargarProductos(),
    //     builder: (BuildContext context,
    //         AsyncSnapshot<List<ProductoModel>> snapshot) {
    //       if (snapshot.hasData) {
    //         final productos = snapshot.data;
    //         return ListView.builder(
    //             itemBuilder: (context, i) => _crearItem(context, productos[i]),
    //             itemCount: productos.length);
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     });
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
        //  productosProvider.borrarProducto(producto.id);
        child: Card(
          child: Column(children: [
            (producto.fotoUrl == null)
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(producto.fotoUrl),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${producto.titulo}- ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto)
                      .then((value) {
                setState(() {});
              }),
            ),
          ]),
        ));
  }
}
