// ignore_for_file: omit_local_variable_types

import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as im;

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor black = PdfColor.fromInt(0x00000000);

const VERSION = '202004';

void main() {
  final Document doc = Document();
  Uint8List fontData =
      File('assets/fonts/Kosugi-Regular.ttf').readAsBytesSync();
  var data = fontData.buffer.asByteData();
  var myFont = Font.ttf(data);
  var myStyle = TextStyle(font: myFont);

  var imagesPath = VERSION + '/assets/images/';
  final logo_temp =
      im.decodeImage(File(imagesPath + 'logo202003.png').readAsBytesSync());
  final logo_img = im.copyResize(logo_temp, width: 350);
  final logo_image = PdfImage(
    doc.document,
    image: logo_img.data.buffer.asUint8List(),
    width: logo_img.width,
    height: logo_img.height,
  );

  final haiku_temp =
      im.decodeImage(File(imagesPath + '2020-03-haiku.png').readAsBytesSync());
  final haiku_img = im.copyResize(haiku_temp, width: 28);
  final haiku_image = PdfImage(
    doc.document,
    image: haiku_img.data.buffer.asUint8List(),
    width: haiku_img.width,
    height: haiku_img.height,
  );

  final hana_temp =
      im.decodeImage(File(imagesPath + 'rose.jpg').readAsBytesSync());
  final hana_img = im.copyResize(hana_temp, width: 200);
  final hana_image = PdfImage(
    doc.document,
    image: hana_img.data.buffer.asUint8List(),
    width: hana_img.width,
    height: hana_img.height,
  );

  doc.addPage(
    Page(
      pageFormat: PdfPageFormat.a3.landscape,
      build: (Context context) => Container(
        decoration: BoxDecoration(
          border: BoxBorder(
              top: true,
              left: true,
              right: true,
              bottom: true,
              color: black,
              width: 4),
        ),
        color: green,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder(
                          top: true,
                          left: true,
                          right: true,
                          bottom: true,
                          color: black,
                          width: 4),
                    ),
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.only(right: 4, bottom: 4),
                    child: Expanded(
                      child: Image(
                        logo_image,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        level: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Haizine Lab note コミュニティとしてオープン",
                                style: myStyle),
                          ],
                        ),
                      ),
                      Paragraph(text: '''
ついにオープンしましたねぇ
嬉しい限りです
                      ''', style: myStyle),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // FIXME: 縦長画像があると、すぐ崩れてしまう
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     padding: EdgeInsets.all(4),
                //     child: Column(
                //       children: [
                //         Expanded(
                //           child: Image(haiku_image),
                //         ),
                //         Text("俳句", style: myStyle)
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image(hana_image),
                      ),
                      Text("写真", style: myStyle)
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Header(
                        level: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("気になったTech NEWS", style: myStyle),
                          ],
                        ),
                      ),
                      Bullet(text: 'ブロックチェーン技術', style: myStyle),
                      Container(
                        child: Header(
                          level: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("regonn&curry.fm(Podcast)", style: myStyle)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Header(
                        level: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("進行中のプロジェクト", style: myStyle)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                      children: [
                        Header(
                          level: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("編集後記", style: myStyle),
                            ],
                          ),
                        ),
                        Paragraph(
                          text: '''
今回、コミュニティを新しく作ったので、活動報告も作っていこうと思い、
PDF生成についても色々と挑戦してみました。
最終的には、コードで残った方がメンテナンスもしやすいかなと、
DartでPDFを生成しているんですが、
思った以上に沼で、画像の画質だとかレイアウトは今後も改善していきたいですね。
                          ''',
                          style: myStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  final File file = File(VERSION + '/haizine-lab.pdf');
  file.writeAsBytesSync(doc.save());
}
