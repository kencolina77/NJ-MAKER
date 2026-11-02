import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const NJMakerApp());
}

class NJMakerApp extends StatefulWidget {
  const NJMakerApp({super.key});

  @override
  State<NJMakerApp> createState() => _NJMakerAppState();
}

class _NJMakerAppState extends State<NJMakerApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NJ MAKER - 3D Print & Design',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF00B4D8),
          secondary: const Color(0xFF9333EA),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF00B4D8),
          secondary: const Color(0xFF9333EA),
          surface: const Color(0xFF0F172A),
        ),
      ),
      home: NJMakerHomeScreen(
        isDark: isDark,
        onToggleTheme: () => setState(() => isDark = !isDark),
      ),
    );
  }
}

class Product3D {
  final String id;
  final String name;
  final String category;
  final double basePrice;
  final String dimensions;
  final String printTime;
  String selectedMaterial;
  String selectedColorName;
  Color selectedColor;

  Product3D({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.dimensions,
    required this.printTime,
    this.selectedMaterial = 'PLA+',
    this.selectedColorName = 'Gradiente NJ (Cian-Violeta)',
    this.selectedColor = const Color(0xFF4F46E5),
  });
}

class NJMakerHomeScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const NJMakerHomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<NJMakerHomeScreen> createState() => _NJMakerHomeScreenState();
}

class _NJMakerHomeScreenState extends State<NJMakerHomeScreen> {
  int currentTab = 0;

  // Estado del Cotizador STL
  double dimX = 110;
  double dimY = 95;
  double dimZ = 120;
  double infill = 25;
  String quoteMaterial = 'PLA+';
  bool needsCadDesign = false;

  final List<Product3D> products = [
    Product3D(
      id: 'nj-1',
      name: 'Letrero Corpóreo 3D Tubular "Custom Brand"',
      category: 'Decoración & Arte',
      basePrice: 32.0,
      dimensions: '240 x 65 x 180 mm',
      printTime: '7h 20m',
    ),
    Product3D(
      id: 'nj-2',
      name: 'Soporte Gamer Dual (Headset + Control PS5/Xbox)',
      category: 'Gadgets & Setups',
      basePrice: 18.0,
      dimensions: '145 x 115 x 255 mm',
      printTime: '4h 30m',
    ),
    Product3D(
      id: 'nj-3',
      name: 'Lámpara Paramétrica Espiral LED "Aura Violet"',
      category: 'Decoración & Arte',
      basePrice: 29.5,
      dimensions: '180 x 180 x 240 mm',
      printTime: '6h 50m',
    ),
    Product3D(
      id: 'nj-4',
      name: 'Engranaje Helicoidal y Repuesto Mecánico CAD',
      category: 'Repuestos & Ingeniería',
      basePrice: 21.0,
      dimensions: '90 x 90 x 45 mm',
      printTime: '3h 40m',
      selectedMaterial: 'PETG',
    ),
  ];

  final List<Map<String, dynamic>> cart = [];

  double get materialMultiplier {
    switch (quoteMaterial) {
      case 'PETG':
        return 1.25;
      case 'TPU':
        return 1.40;
      case 'RESINA 8K':
        return 1.75;
      default:
        return 1.0;
    }
  }

  double get estimatedQuotePrice {
    final volCm3 = (dimX * dimY * dimZ) / 1000.0;
    final grams = (volCm3 * 0.27 * (0.18 + (infill / 100.0) * 0.65)).clamp(15, 2000);
    final base = 3.5 + (grams * 0.11 * materialMultiplier);
    return base + (needsCadDesign ? 15.0 : 0.0);
  }

  void addToCart(String title, String specs, double price) {
    setState(() {
      cart.add({'title': title, 'specs': specs, 'price': price});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title agregado al pedido de NJ MAKER'),
        backgroundColor: const Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF3B82F6), Color(0xFF9333EA)],
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'NJ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    children: const [
                      TextSpan(text: 'NJ MA'),
                      TextSpan(
                        text: 'KER',
                        style: TextStyle(color: Color(0xFF7C3AED)),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '3D PRINT & DESIGN',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00B4D8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.wb_sunny : Icons.nightlight_round),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentTab,
        children: [
          _buildCatalogTab(),
          _buildQuoterTab(),
          _buildCartTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (idx) => setState(() => currentTab = idx),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.view_in_ar_outlined),
            selectedIcon: Icon(Icons.view_in_ar),
            label: 'Catálogo 3D',
          ),
          const NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Cotizador STL',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cart.isNotEmpty,
              label: Text('${cart.length}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Pedido WhatsApp',
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFF4F46E5), Color(0xFF9333EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IMPRESIÓN 3D FDM • RESINA 8K • DISEÑO CAD',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Materializamos tus Ideas en NJ MAKER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Personaliza el filamento Cian-Violeta o cotiza tu propio archivo STL en tiempo real.',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...products.map((prod) => Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF00B4D8),
                          ),
                        ),
                        Text(
                          '⏱ ${prod.printTime}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prod.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📐 ${prod.dimensions} • Material: ${prod.selectedMaterial}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${prod.basePrice.toStringAsFixed(2)} USD',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => addToCart(
                            prod.name,
                            '${prod.selectedMaterial} • ${prod.selectedColorName}',
                            prod.basePrice,
                          ),
                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                          label: const Text('Agregar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildQuoterTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Cotizador Slicer 3D (.STL / CAD)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ancho X: ${dimX.round()} mm'),
                Slider(
                  value: dimX,
                  min: 15,
                  max: 280,
                  onChanged: (v) => setState(() => dimX = v),
                ),
                Text('Largo Y: ${dimY.round()} mm'),
                Slider(
                  value: dimY,
                  min: 15,
                  max: 280,
                  onChanged: (v) => setState(() => dimY = v),
                ),
                Text('Alto Z: ${dimZ.round()} mm'),
                Slider(
                  value: dimZ,
                  min: 15,
                  max: 280,
                  onChanged: (v) => setState(() => dimZ = v),
                ),
                SwitchListTile(
                  title: const Text('Incluir Diseño CAD 3D desde cero (+$15)'),
                  value: needsCadDesign,
                  onChanged: (v) => setState(() => needsCadDesign = v),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Estimado:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${estimatedQuotePrice.toStringAsFixed(2)} USD',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => addToCart(
                      'Impresión 3D a Medida (${dimX.round()}x${dimY.round()}x${dimZ.round()}mm)',
                      '${quoteMaterial} • Infill ${infill.round()}%',
                      estimatedQuotePrice,
                    ),
                    child: const Text('Añadir Cotización al Pedido'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartTab() {
    final total = cart.fold<double>(0, (sum, item) => sum + (item['price'] as double));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orden de Pedido NJ MAKER',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('Tu carrito 3D está vacío'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (ctx, i) {
                      final item = cart[i];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text(item['specs']),
                        trailing: Text('\$${item['price'].toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
          if (cart.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final summary = cart
                      .map((e) => '- ${e['title']} (\$${e['price'].toStringAsFixed(2)})')
                      .join('\n');
                  Clipboard.setData(
                    ClipboardData(
                      text: 'PEDIDO NJ MAKER (3D PRINT & DESIGN):\n$summary\nTOTAL: \$${total.toStringAsFixed(2)} USD',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pedido copiado para enviar por WhatsApp')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text('Copiar Pedido WhatsApp (\$${total.toStringAsFixed(2)} USD)'),
              ),
            ),
        ],
      ),
    );
  }
}