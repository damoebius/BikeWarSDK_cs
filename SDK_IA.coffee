###
   BikeWar CoffeeScript SDK
   http://www.codeofwar.net


   Copyright 2014 Tamina
   Released under the MIT license
   http://opensource.org/licenses/MIT

   author : david mouton
###


###
   Le nom de l'IA
   @property name
   @type String
###
name = "noname"


color = 0

###
   Le message à sortir dans la console à la fin du tour
   @property debugMessage
   @type String
###
debugMessage=""

###
   Id de l'IA
   @property id
   @type String
###
id = 0

###
  @internal method
###
@onmessage = (event) ->
  if event.data?
    turnMessage = event.data
    id = turnMessage.playerId
    orders = []
    msg = '';
    try
      orders = getOrders(turnMessage.data)
      msg = debugMessage
    catch e
      msg = 'Error : ' + e
    postMessage(new TurnResult(orders, msg))
  else postMessage("data null")


###
   Cette méthode est appelée par le système tout les tours
   @method getOrders
   @param    context {MapData} l'ensemble des données de la partie
   @return    result {Array<Order>} la liste des ordres à exécuter ce tour
###
getOrders = (context) -> []

###
   La Map
   <br/> Contient l'ensemble des données de la partie
   @class MapData
   @constructor
###
class MapData
  constructor: () ->

  ###
     La liste des joueurs
     @property players
     @type Array<Player>
  ###
  players : []

  ###
     La liste des stations de vélo
     @property stations
     @type Array<BikeStation>
  ###
  stations : []

  ###
     La liste des camions
     @property trucks
     @type Array<Truck>
  ###
  trucks : []

  ###
     La date courante
     @property currentTime
     @type Date
  ###
  currentTime : new Date()

  ###
     La liste des routes
     @property roads
     @type Array<Junction>
  ###
  roads : []

###
   Station de Vélo
   @class BikeStation
   @constructor
###
class BikeStation
  constructor: () ->

  ###
     L'id de la station
     @property id
     @type Float
  ###
  id : 0.0

  ###
     Le nombre de vélo
     @property bikeNum
     @type Int
  ###
  bikeNum : 0

  ###
     Le nombre d'emplacement pour vélo
     @property slotNum
     @type Int
  ###
  slotNum : 0

  ###
     La position de la station sur la Map
     @property position
     @type Junction
  ###
  position : null

  ###
     Le proprietaire
     @property owner
     @type Player
  ###
  owner : null

  ###
     Le profil de la station.
     le nombre moyen de vélo en station entre 00h00 et 23h45, toutes les 15 minutes.
     @property profile
     @type Array<Int>
  ###
  profile : []

  ###
     Le nom de la station
     @property name
     @type String
  ###
  name : ''


###
   Classe de base des Ordres à éxécuter par le systeme
   @class Order
###
class Order
  constructor: (@truckId,@targetStationId,@type) ->

###
   Ordre de déplacement
   @class MoveOrder
   @constructor
   @param    truckId  {Float} L'id du camion concerné par cet ordre
   @param    targetStationId {Float} La station de destination
###
class MoveOrder extends Order
  constructor: (@truckId,@targetStationId) ->
    super truckId, targetStationId, OrderType.MOVE

###
   Ordre de chargement
   @class LoadingOrder
   @constructor
   @param    truckId  {Float} L'id du camion concerné par cet ordre
   @param    targetStationId {Float} La station de destination
   @param    bikeNum {Int} Le nombre de vélo à charger
###
class LoadingOrder extends Order
  constructor: (@truckId,@targetStationId, @bikeNum) ->
    super truckId, targetStationId, OrderType.LOAD

###
   Ordre de déchargement des vélos
   @class UnLoadingOrder
   @constructor
   @param    truckId  {Float} L'id du camion concerné par cet ordre
   @param    targetStationId {Float} La station ciblée
   @param    bikeNum {Int} Le nombre de vélo à décharger
###
class UnLoadingOrder extends Order
  constructor: (@truckId,@targetStationId, @bikeNum) ->
    super truckId, targetStationId, OrderType.UNLOAD


###
   Enumeration des types d'ordres
   @class OrderType
###
class OrderType
  ###
     Ordre de déplacement
     @property MOVE
     @type String
  ###
  @MOVE : 'move';

  ###
     Ordre de chargement de vélo
     @property LOAD
     @type String
  ###
  @LOAD : "load";

  ###
     Ordre de déchargement de vélo
     @property UNLOAD
     @type String
  ###
  @UNLOAD :"unload";

  ###
     Ordre de rien du tout
     @property NONE
     @type String
  ###
  @NONE : "none";

###
  Classe utilitaire
  @internal
###
class UID
  @lastUID : 0
  @get : () ->
    @lastUID++
    @lastUID

###
   Joueur
   @class Player
   @constructor
   @param    name {String}
   @param    color {String}
   @param    script {String}
###
class Player
  constructor:(@name, @script, @color)->

  ###
     Id de l'IA
     @property id
     @type String
  ###
  id : UID.get()

###
   Tendance d'une Station
   @class Trend
###
class Trend
  ###
   Décroissante
   @property DECREASE
   @type Int
   @default -1
   @static
  ###
  @DECREASE: -1;

  ###
     Croissante
     @property INCREASE
     @type Int
     @default 1
     @static
  ###
  @INCREASE: 1;

  ###
     Stable
     @property STABLE
     @type Int
     @default 0
     @static
  ###
  @STABLE: 0;

###
   Camion
   @class Truck
###
class Truck
  constructor:(@owner, @currentStation)->
    if currentStation != null
      @position = currentStation.position
  ###
     L'Id du camion
     @property id
     @type Float
  ###
  id : UID.get()

  ###
     Le nombre de vélo embarqué
     @property bikeNum
     @type Int
  ###
  bikeNum:0

  ###
     La position du camion
     @property position
     @type Point
  ###
  position: null

###
  @internal model
###
class TurnResult
  constructor: (@orders,@consoleMessage = "") ->
  error : ""

###
  @model Point
  @param x:Number
  @param y:Number
###
class Point
  constructor: (@x,@y) ->

###
   @class Junction
   @extends Point
   @param x:Number
   @param y:Number
   @param id:String
###
class Junction extends Point
  constructor: (@x,@y,@id) ->
    super x y

  ###
     La liste des Junction liées
     @property links
     @type Array<Junction>
  ###
  links : []



###
  Classe utilitaire
###
class GameUtils
  ###
    @param p1:Point
    @param p2:Point
    @return result:Number la distance entre deux points
  ###
  @getDistanceBetween : (p1,p2) ->
    Math.sqrt(Math.pow(p2.x - p1.x,2) + Math.pow(p2.y - p1.y,2))

  ###
     Indique le nombre de tour necessaire à un camion pour aller d'une station à une autre
     @method getTravelDuration
     @param	source {BikeStation} la station d'origine
     @param   target {BikeStation} la station de destination
     @param   map {MapData} la map
     @return	result {Int} le nombre de tour
     @static
  ###
  @getTravelDuration : (source, target, map)->
    result = 0
    p = GameUtils.getPath(source,target,map)
    _g1 = 0;
    _g = p.get_length() - 1;
    while(_g1 < _g)
      i = _g1++
      result += Math.ceil(GameUtils.getDistanceBetween(p.getItemAt(i),p.getItemAt(i + 1)) / Game.TRUCK_SPEED)
    return result


  ###
    Si la station se trouve dans sa zone optimale
    @method hasStationEnoughBike
    @param	station {BikeStation} la station
    @return	result {Bool}
    @static
  ###
  @hasStationEnoughBike : (station)->
    station.bikeNum > station.slotNum/4 && station.bikeNum < station.slotNum/4*3

  ###
     Indique la tendance d'une station à un instant particulier
     @method getBikeStationTrend
     @param	target {BikeStation} la station
     @param   time {Date} l'heure de la journée
     @return	result {Trend} la tendance
     @static
  ###
  @getBikeStationTrend : (target, time )->
    currentIndex = time.getHours()   4 +  Math.floor(  time.getMinutes()   4 / 60 )
    nextIndex = currentIndex + 1
    if nextIndex + 1 > target.profile.length
      nextIndex = 0
    target.profile[nextIndex] - target.profile[currentIndex]


  ###
     Récupere le chemin le plus court entre deux stations
     @method getPath
     @param	fromStation {BikeStation} la station d'origine
     @param   toStation {BikeStation} la station de destination
     @param   map {MapData} la map
     @return	result {Path} le chemin
     @static
  ###
  @getPath : (fromStation,toStation, map)->
    p = new PathFinder()
    p.getPath(fromStation,toStation,map)


###
   Constantes du jeu
   @class Game
###
class Game

  ###
   La vitesse d'execution d'un tour.
   @property GAME_SPEED
   @type Int
   @static
  ###
  @GAME_SPEED : 1000
  ###
     Le nombre maximum de tour
     @property GAME_MAX_NUM_TURN
     @type Int
     @static
  ###
  @GAME_MAX_NUM_TURN : 500
  ###
     La vitesse d'un camion
     @property TRUCK_SPEED
     @type Int
     @static
  ###
  @TRUCK_SPEED : 60
  ###
     La capacité d'un camion
     @property TRUCK_NUM_SLOT
     @type Int
     @static
  ###
  @TRUCK_NUM_SLOT : 10
  ###
     La durée maximale du tour d'une IA. Si l'IA dépasse cette durée, elle passe en timeout.
     @property MAX_TURN_DURATION
     @type Int
     @static
  ###
  @MAX_TURN_DURATION : 1000
  ###
     La durée d'un tour en ms. ex 15 minutes/tours
     @property TURN_TIME
     @type Int
     @static
  ###
  @TURN_TIME : 1000*30*15

class PathFinder
  constructor : () ->
  _inc : 0
  _paths : []
  map : {}
  _result : null

  getPath: (fromStation,toStation,@map)->
    @_source = @getJunctionByStation(fromStation)
    @_target = @getJunctionByStation(toStation)
    p = new Path()
    p.push(@_source)
    @_paths.push(p)
    find()
    @_result

  getJunctionByStation : (station) ->
    result = null
    _g1 = 0
    _g = @map.roads.length
    while(_g1 < _g)
      i = _g1++
      j = @map.roads[i]
      if j.x == station.position.x and j.y == station.position.y
        result = j
        break
    result

  find: () ->
    result = false
    @_inc++
    paths = @_paths.slice()
    _g1 = 0
    _g = paths.length
    while _g1 < _g
      i = _g1++
      if @checkPath(paths[i])
        result = true
        break
    if !result and @_inc < 50
      @find()

  checkPath: (target) ->
    result = false
    currentJunction = target.getLastItem()
    _g1 = 0
    _g = currentJunction.links.length
    while(_g1 < _g)
      i = _g1++
      nextJunction = currentJunction.links[i]
      if nextJunction.id == @_target.id
        result = true
        p = target.copy()
        p.push(nextJunction)
        @_result = p
        break
      else if !Path.contains(nextJunction,@_paths)
        p1 = target.copy()
        p1.push(nextJunction)
        @_paths.push(p1)
    HxOverrides.remove(this._paths,target);
    result

class Path
  constructor : (@_content) ->

  @contains : (item,list) ->
    result = false
    _g1 = 0
    _g = list.length
    while _g1 < _g
      i = _g1++
      if list[i].hasItem(item)
        result = true
        break
    result

  getLastItem: () ->
    @_content[@_content.length - 1]

  hasItem: (item) ->
    result = false
    _g1 = 0
    _g = @_content.length
    while _g1 < _g
      i = _g1++
      if item.id == @_content[i].id
        result = true
        break
    result

  getGuide: () ->
    result = []
    _g1 = 0
    _g = @_content.length
    while _g1 < _g
      i = _g1++
      result.push(@_content[i].x - 8)
      result.push(@_content[i].y - 8)
    result

    getItemAt: (index) ->
      @_content[index]

    push: (item) ->
      @_content.push(item)

    remove: (item) ->
      HxOverrides.remove(@_content,item)

    copy: () ->
      new Path(@_content.slice())

    length: () ->
      @_content.length;

class HxOverrides

  @indexOf : (a,obj,i) ->
    len = a.length
    result = -1
    if i < 0
      i += len;
      if i < 0
        i = 0
    while i < len
      if a[i] == obj
        result = i
        break
      i++
    result

  @remove : (a,obj) ->
    result = true
    i = HxOverrides.indexOf(a,obj,0)
    if i == -1
      result = false
    else
      a.splice(i,1)
    return result