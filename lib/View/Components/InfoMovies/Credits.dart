import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ------------ CASTER COMPONENT ------------ //
class Credits extends StatelessWidget {
  Credits({required this.idMovie});

  String idMovie;

  // ------- Fetch Casters Movie API ID ------- //
  Future<List> fetch() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${idMovie}/credits?api_key=78e7e6ae60efeac373ce12307172c271&language=pt-br');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    var itemCount = jsonResponse['cast'];
    return itemCount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Elenco',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 75,
            child: FutureBuilder<List>(
              future: fetch(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 500,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 100,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var MovieApi = snapshot.data![index];
                        var url =
                            "https://www.themoviedb.org/t/p/w600_and_h900_bestv2";

                        if (MovieApi["profile_path"] != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  '${url}${MovieApi["profile_path"]}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: SizedBox(
                                  child: Text('${MovieApi["name"]}',
                                      textAlign: TextAlign.center,
                                      style:
                                          GoogleFonts.montserrat(fontSize: 10)),
                                ),
                              )
                            ],
                          );
                        } else if (MovieApi["profile_path"] == null) {}
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SizedBox(
                                child: Text('${MovieApi["name"]}',
                                    textAlign: TextAlign.center,
                                    style:
                                        GoogleFonts.montserrat(fontSize: 10)),
                              ),
                            )
                          ],
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Casters não Encontrados'),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }
}
